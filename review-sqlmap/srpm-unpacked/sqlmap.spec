# binaries are exploits, intended to be used on remote systems
%define _binaries_in_noarch_packages_terminate_build 0

# exclude binaries from dependencies computing
%global __requires_exclude_from ^%{_datadir}/%{name}/udf/.*$
%global __provides_exclude_from ^%{_datadir}/%{name}/udf/.*$

Name:           sqlmap
Version:        1.5.12
Release:        dev
Summary:        Automatic SQL injection and database takeover tool
Group:          Security
License:        GPLv3
URL:            http://sqlmap.org/
Source0:        https://github.com/sqlmapproject/sqlmap/tarball/master/sqlmapproject-sqlmap-1.5.12-0-g90b145e.tar.gz
BuildArch:      noarch
Requires:       python3-requests

%description
sqlmap is an open source penetration testing tool that automates the process
of detecting and exploiting SQL injection flaws and taking over of database
servers. It comes with a powerful detection engine, many niche features for
the ultimate penetration tester and a broad range of switches lasting from
database fingerprinting, over data fetching from the database, to accessing
the underlying file system and executing commands on the operating system
via out-of-band connections.

%prep
%setup -q -n sqlmapproject-sqlmap-90b145e

%install
install -d -m 755 %{buildroot}%{_datadir}/%{name}
install -m 755 sqlmap.py %{buildroot}%{_datadir}/%{name}
cp -pr extra %{buildroot}%{_datadir}/%{name}
cp -pr lib %{buildroot}%{_datadir}/%{name}
cp -pr plugins %{buildroot}%{_datadir}/%{name}
cp -pr data %{buildroot}%{_datadir}/%{name}
cp -pr thirdparty %{buildroot}%{_datadir}/%{name}
cp -pr tamper %{buildroot}%{_datadir}/%{name}
#cp -pr doc %{buildroot}%{_datadir}/%{name}

install -d -m 755 %{buildroot}%{_bindir}
cat > %{buildroot}%{_bindir}/sqlmap <<'EOF'
#!/bin/sh
cd %{_datadir}/%{name}
./sqlmap.py "$@"
EOF
chmod +x %{buildroot}%{_bindir}/sqlmap

sed -i 's|/usr/bin/env python$|/usr/bin/python3|' %{buildroot}%{_datadir}/%{name}/*.py %{buildroot}%{_datadir}/%{name}/*/*/*.py

install -d -m 755 %{buildroot}%{_sysconfdir}
install -m 644 sqlmap.conf %{buildroot}%{_sysconfdir}
pushd %{buildroot}%{_datadir}/%{name}
ln -s ../../..%{_sysconfdir}/sqlmap.conf .

%files
%doc doc/*
%{_datadir}/%{name}
%{_bindir}/%{name}
%config(noreplace) %{_sysconfdir}/%{name}.conf

%changelog
* Fri Dec 03 2021 Sandipan Roy <bytehackr@fedoraproject.org> 1.5.12-dev
- new package

