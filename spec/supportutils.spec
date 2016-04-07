# spec file for package supportutils
#
# Copyright (C) 2008-2014 SUSE LLC
#
# This file and all modifications and additions to the pristine
# package are under the same license as the package itself.
#
# Please submit bug fixes or comments via 
#  http://en.opensuse.org/Supportutils#Reporting_Bugs
#

# norootforbuild
# neededforbuild  

Name:         supportutils
Summary:      Support Troubleshooting Tools
URL:          http://en.opensuse.org/Supportutils
License:      GPL-2.0
Group:        System/Monitoring
Autoreqprov:  on
Version:      1.20
Release:      125
Source:       %{name}-%{version}.tar.gz
BuildRoot:    %{_tmppath}/%{name}-%{version}-build
BuildArch:    noarch
Provides:     supportconfig-plugin-resource
Provides:     supportconfig-plugin-tag
Provides:     supportconfig-plugin-icommand
Requires:     tar
Requires:     bash

%description
A package containing troubleshooting tools. This package contains 
the following: supportconfig, chkbin, getappcore, analyzevmcore

Authors:
--------
    Jason Record <jrecord@suse.com>
    Mike Latimer <mlatimer@suse.com>

%prep
%setup -q

%build
gzip -9f man/*3
gzip -9f man/*5
gzip -9f man/*8

%install
pwd;ls -la
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT/sbin
install -d $RPM_BUILD_ROOT/etc
install -d $RPM_BUILD_ROOT/usr/share/man/man3
install -d $RPM_BUILD_ROOT/usr/share/man/man5
install -d $RPM_BUILD_ROOT/usr/share/man/man8
install -d $RPM_BUILD_ROOT/usr/lib/supportconfig/resources
install -d $RPM_BUILD_ROOT/usr/share/doc/packages/%{name}
install -m 444 man/COPYING.GPLv2 $RPM_BUILD_ROOT/usr/share/doc/packages/%{name}
install -m 544 bin/supportconfig $RPM_BUILD_ROOT/sbin
install -m 544 bin/chkbin $RPM_BUILD_ROOT/sbin
install -m 544 bin/getappcore $RPM_BUILD_ROOT/sbin
install -m 544 bin/analyzevmcore $RPM_BUILD_ROOT/sbin
install -m 444 bin/scplugin.rc $RPM_BUILD_ROOT/usr/lib/supportconfig/resources
install -m 644 man/*.3.gz $RPM_BUILD_ROOT/usr/share/man/man3
install -m 644 man/*.5.gz $RPM_BUILD_ROOT/usr/share/man/man5
install -m 644 man/*.8.gz $RPM_BUILD_ROOT/usr/share/man/man8

%files
%defattr(-,root,root)
/sbin/*
%dir /usr/lib/supportconfig
%dir /usr/lib/supportconfig/resources
%dir /usr/share/doc/packages/%{name}
%doc /usr/share/doc/packages/%{name}/*
/usr/lib/supportconfig/resources/*
%doc /usr/share/man/man5/*
%doc /usr/share/man/man3/*
%doc /usr/share/man/man8/*

%clean
rm -rf $RPM_BUILD_ROOT

%changelog

