
#
# This file is not needed for review, and is only used for the
# shell API plugin. No need to modify it or anything.
#

declare -f +x module
PATH=/bin:/usr/bin:/sbin/:/usr/sbin

declare -A FR_FLAGS
FR_FLAGS[EPEL6]=''
FR_FLAGS[EPEL7]=''
FR_FLAGS[DISTTAG]=''
FR_FLAGS[BATCH]=''
FR_FLAGS[EXARCH]=''

declare -A FR_SETTINGS 
FR_SETTINGS[bz_url]="https://bugzilla.redhat.com"
FR_SETTINGS[log]="<RootLogger root (DEBUG)>"
FR_SETTINGS[cache]=""
FR_SETTINGS[resultdir]=""
FR_SETTINGS[init_done]="True"
FR_SETTINGS[uniqueext]=""
FR_SETTINGS[configdir]=""
FR_SETTINGS[log_level]="20"
FR_SETTINGS[prebuilt]=""
FR_SETTINGS[verbose]=""
FR_SETTINGS[name]="sqlmap"
FR_SETTINGS[use_colors]="True"
FR_SETTINGS[session_log]="/home/sandipan/.cache/fedora-review.log"
FR_SETTINGS[bug]=""
FR_SETTINGS[url]=""
FR_SETTINGS[copr_build_descriptor]=""
FR_SETTINGS[list_checks]=""
FR_SETTINGS[list_flags]=""
FR_SETTINGS[list_plugins]=""
FR_SETTINGS[version]=""
FR_SETTINGS[flags]=""
FR_SETTINGS[repo]=""
FR_SETTINGS[mock_config]="fedora-rawhide-x86_64"
FR_SETTINGS[no_report]=""
FR_SETTINGS[nobuild]=""
FR_SETTINGS[mock_options]="--no-bootstrap-chroot --no-cleanup-after --no-clean"
FR_SETTINGS[other_bz]=""
FR_SETTINGS[plugins_arg]=""
FR_SETTINGS[single]=""
FR_SETTINGS[rpm_spec]=""
FR_SETTINGS[exclude]=""
FR_SETTINGS[checksum]="sha256"
FR_SETTINGS[plugins]=""

export FR_REVIEWDIR='/home/sandipan/Desktop/fedora/sqlmap-fedora-rpm/review-sqlmap'
export HOME=$FR_REVIEWDIR
cd $HOME

export FR_NAME='sqlmap'
export FR_VERSION='1.5.12'
export FR_RELEASE='dev'
export FR_GROUP='Security'
export FR_LICENSE='GPLv3'
export FR_URL='http://sqlmap.org/'

export Source0="https://github.com/sqlmapproject/sqlmap/tarball/master/sqlmapproject-sqlmap-1.5.12-0-g90b145e.tar.gz"



export FR_PREP='cd '\''/home/sandipan/rpmbuild/BUILD'\''
rm -rf '\''sqlmapproject-sqlmap-90b145e'\''
/usr/bin/tar -xof '\''/home/sandipan/rpmbuild/SOURCES/sqlmapproject-sqlmap-1.5.12-0-g90b145e.tar.gz'\''
STATUS=$?
if [ $STATUS -ne 0 ]; then
exit $STATUS
fi
cd '\''sqlmapproject-sqlmap-90b145e'\''
/usr/bin/chmod -Rf a+rX,u+w,g-w,o-w .'
export FR_BUILD=
export FR_INSTALL='install -d -m 755 /home/sandipan/rpmbuild/BUILDROOT/sqlmap-1.5.12-dev.x86_64/usr/share/sqlmap
install -m 755 sqlmap.py /home/sandipan/rpmbuild/BUILDROOT/sqlmap-1.5.12-dev.x86_64/usr/share/sqlmap
cp -pr extra /home/sandipan/rpmbuild/BUILDROOT/sqlmap-1.5.12-dev.x86_64/usr/share/sqlmap
cp -pr lib /home/sandipan/rpmbuild/BUILDROOT/sqlmap-1.5.12-dev.x86_64/usr/share/sqlmap
cp -pr plugins /home/sandipan/rpmbuild/BUILDROOT/sqlmap-1.5.12-dev.x86_64/usr/share/sqlmap
cp -pr data /home/sandipan/rpmbuild/BUILDROOT/sqlmap-1.5.12-dev.x86_64/usr/share/sqlmap
cp -pr thirdparty /home/sandipan/rpmbuild/BUILDROOT/sqlmap-1.5.12-dev.x86_64/usr/share/sqlmap
cp -pr tamper /home/sandipan/rpmbuild/BUILDROOT/sqlmap-1.5.12-dev.x86_64/usr/share/sqlmap
#cp -pr doc /home/sandipan/rpmbuild/BUILDROOT/sqlmap-1.5.12-dev.x86_64/usr/share/sqlmap
install -d -m 755 /home/sandipan/rpmbuild/BUILDROOT/sqlmap-1.5.12-dev.x86_64/usr/bin
cat > /home/sandipan/rpmbuild/BUILDROOT/sqlmap-1.5.12-dev.x86_64/usr/bin/sqlmap <<'\''EOF'\''
#!/bin/sh
cd /usr/share/sqlmap
./sqlmap.py "$@"
EOF
chmod +x /home/sandipan/rpmbuild/BUILDROOT/sqlmap-1.5.12-dev.x86_64/usr/bin/sqlmap
sed -i '\''s|/usr/bin/env python$|/usr/bin/python3|'\'' /home/sandipan/rpmbuild/BUILDROOT/sqlmap-1.5.12-dev.x86_64/usr/share/sqlmap/*.py /home/sandipan/rpmbuild/BUILDROOT/sqlmap-1.5.12-dev.x86_64/usr/share/sqlmap/*/*/*.py
install -d -m 755 /home/sandipan/rpmbuild/BUILDROOT/sqlmap-1.5.12-dev.x86_64/etc
install -m 644 sqlmap.conf /home/sandipan/rpmbuild/BUILDROOT/sqlmap-1.5.12-dev.x86_64/etc
pushd /home/sandipan/rpmbuild/BUILDROOT/sqlmap-1.5.12-dev.x86_64/usr/share/sqlmap
ln -s ../../../etc/sqlmap.conf .'

declare -A FR_FILES
FR_FILES[sqlmap]='%doc doc/*
/usr/share/sqlmap
/usr/bin/sqlmap
%config(noreplace) /etc/sqlmap.conf'

declare -A FR_DESCRIPTION


export FR_FILES FR_DESCRIPTION

export FR_PASS=80
export FR_FAIL=81
export FR_PENDING=82
export FR_NOT_APPLICABLE=83


function get_used_rpms()
# returns (stdout) list of used rpms if found, else returns 1
{
    cd $FR_REVIEWDIR
    if test  "${FR_SETTINGS[prebuilt]}" = True
    then
        files=( $(ls ../*.rpm 2>/dev/null | grep -v .src.rpm) )                || files=( '@@' )
    else
        files=( $(ls results/*.rpm 2>/dev/null | grep -v .src.rpm) )                || files=( '@@' )
    fi
    test -e ${files[0]} || return 1
    echo "${files[@]}"
    cd $OLDPWD
}

function unpack_rpms()
# Unpack all non-src rpms in results into rpms-unpacked, one dir per rpm.
{
    [ -d rpms-unpacked ] && return 0
    rpms=( $( get_used_rpms ) ) || return 1
    mkdir rpms-unpacked
    cd rpms-unpacked
    retval=0
    for rpm_path in ${rpms[@]};  do
        rpm=$( basename $rpm_path)
        mkdir $rpm
        cd $rpm
        rpm2cpio ../../$rpm_path | cpio -imd &>/dev/null
        cd ..
    done
    cd ..
}

function unpack_sources()
# Unpack sources in upstream into upstream-unpacked
# Ignores (reuses) already unpacked items.
{
    sources=( $(cd upstream; ls) ) || sources=(  )
    if [[ ${#sources[@]} -eq 0 || ! -e "upstream/${sources[0]}" ]]; then
       return $FR_NOT_APPLICABLE
    fi
    for source in "${sources[@]}"; do
        mkdir upstream-unpacked/$source 2>/dev/null || continue
        rpmdev-extract -qfC  upstream-unpacked/$source upstream/$source ||            cp upstream/$source upstream-unpacked/$source
    done
}

function attach()
# Usage: attach <sorting hint> <header>
# Reads attachment from stdin
{
    startdir=$(pwd)
    cd $FR_REVIEWDIR
    for (( i = 0; i < 10; i++ )); do
        test -e $FR_REVIEWDIR/.attachments/*$i || break
    done
    if [ $i -eq 10 ]; then
        echo "More than 10 attachments! Giving up" >&2
        exit 1
    fi
    sort_hint=$1
    shift
    title=${*//\/ }
    file="$sort_hint;${title/;/:};$i"
    cat > .attachments/"$file"
    cd $startdir
}

