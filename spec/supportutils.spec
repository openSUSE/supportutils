#
# spec file for package supportutils
#
# Copyright (c) 2017 SUSE LINUX Products GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

%define support_libdir /usr/lib/supportconfig

Name:           supportutils
Version:        3.1
Release:        0
Summary:        Support Troubleshooting Tools
License:        GPL-2.0
Group:          System/Monitoring
Url:            https://github.com/g23guy/supportutils
Source:         %{name}-%{version}.tar.gz
Requires:       sysfsutils
Requires:       tar
Requires:       which
Requires:       util-linux-systemd
Requires:       net-tools
Requires:       ncurses-utils
Requires:       kmod-compat
Requires:       iproute2
Provides:       supportconfig-plugin-resource
Provides:       supportconfig-plugin-tag
Provides:       supportconfig-plugin-icommand
BuildArch:      noarch

%description
A package containing troubleshooting tools. This package contains
the following: supportconfig, chkbin, getappcore, analyzevmcore

%prep
%setup -q

%build
gzip -9f man/*3
gzip -9f man/*5
gzip -9f man/*8

%install
pwd;ls -la
install -d %{buildroot}/sbin
install -d %{buildroot}/etc
install -d %{buildroot}%{_mandir}/man3
install -d %{buildroot}%{_mandir}/man5
install -d %{buildroot}%{_mandir}/man8
install -d %{buildroot}%{support_libdir}/resources
install -d %{buildroot}%{support_libdir}/plugins
install -d %{buildroot}%{_docdir}/%{name}
install -m 444 man/COPYING.GPLv2 %{buildroot}%{_docdir}/%{name}
install -m 544 bin/supportconfig %{buildroot}/sbin
install -m 544 bin/chkbin %{buildroot}/sbin
install -m 544 bin/getappcore %{buildroot}/sbin
install -m 544 bin/analyzevmcore %{buildroot}/sbin
install -m 444 bin/scplugin.rc %{buildroot}%{support_libdir}/resources
install -m 444 bin/supportconfig.rc %{buildroot}%{support_libdir}/resources
install -m 644 man/*.3.gz %{buildroot}%{_mandir}/man3
install -m 644 man/*.5.gz %{buildroot}%{_mandir}/man5
install -m 644 man/*.8.gz %{buildroot}%{_mandir}/man8

%files
%defattr(-,root,root)
/sbin/supportconfig
/sbin/chkbin
/sbin/getappcore
/sbin/analyzevmcore
%dir %{support_libdir}
%dir %{support_libdir}/resources
%dir %{support_libdir}/plugins
%dir %{_docdir}/%{name}
%doc %{_docdir}/%{name}/*
%{support_libdir}/resources/*
%doc %{_mandir}/man5/*
%doc %{_mandir}/man3/*
%doc %{_mandir}/man8/*

%changelog
