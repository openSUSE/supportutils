#
# spec file for package supportutils (Version 1.20-80)
#
# Copyright (C) 2008-2013 SUSE Linux Products GmbH, Nuernberg, Germany
# This file and all modifications and additions to the pristine
# package are under the same license as the package itself.
#
# Please submit bug fixes or comments via 
#  http://en.opensuse.org/Supportutils#Reporting_Bugs
#

# norootforbuild
# neededforbuild  

Name:         supportutils
URL:          http://en.opensuse.org/Supportutils
License:      GPLv2
Group:        System/Management
Autoreqprov:  on
Version:      1.20
Release:      80.131216.PTF.1
Source:       %{name}-%{version}.tar.gz
Summary:      Support Troubleshooting Tools
BuildRoot:    %{_tmppath}/%{name}-%{version}-build
BuildArch:    noarch
Provides:     supportconfig-plugin-resource
Provides:     supportconfig-plugin-tag
Provides:     supportconfig-plugin-icommand
Requires:     tar
Requires:     bash

%description
A package containing troubleshooting tools. This package contains 
the following: supportconfig, chkbin, schealth, getappcore, analyzevmcore

Please submit bug fixes or comments via:
    http://en.opensuse.org/Supportutils#Reporting_Bugs

Authors:
--------
    Jason Record <jrecord@suse.com>
    Mike Latimer <mlatimer@suse.com>
    

%prep
%setup -q
%build
gzip -9f supportconfig.8
gzip -9f chkbin.8
gzip -9f getappcore.8
gzip -9f analyzevmcore.8
gzip -9f supportconfig.conf.5
gzip -9f scplugin.rc.3
gzip -9f section_header.3
gzip -9f pconf_files.3
gzip -9f plog_files.3
gzip -9f plugin_message.3
gzip -9f plugin_tag.3
gzip -9f plugin_command.3
gzip -9f validate_rpm.3

%install
pwd;ls -la
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT/sbin
install -d $RPM_BUILD_ROOT/usr/bin
install -d $RPM_BUILD_ROOT/etc
install -d $RPM_BUILD_ROOT/usr/share/man/man8
install -d $RPM_BUILD_ROOT/usr/share/man/man5
install -d $RPM_BUILD_ROOT/usr/share/man/man3
install -d $RPM_BUILD_ROOT/usr/lib/supportconfig/resources
install -m 544 supportconfig $RPM_BUILD_ROOT/sbin
install -m 644 supportconfig.8.gz $RPM_BUILD_ROOT/usr/share/man/man8
install -m 644 supportconfig.conf.5.gz $RPM_BUILD_ROOT/usr/share/man/man5
install -m 644 scplugin.rc.3.gz $RPM_BUILD_ROOT/usr/share/man/man3
install -m 644 section_header.3.gz $RPM_BUILD_ROOT/usr/share/man/man3
install -m 644 pconf_files.3.gz $RPM_BUILD_ROOT/usr/share/man/man3
install -m 644 plog_files.3.gz $RPM_BUILD_ROOT/usr/share/man/man3
install -m 644 plugin_message.3.gz $RPM_BUILD_ROOT/usr/share/man/man3
install -m 644 plugin_tag.3.gz $RPM_BUILD_ROOT/usr/share/man/man3
install -m 644 plugin_command.3.gz $RPM_BUILD_ROOT/usr/share/man/man3
install -m 644 validate_rpm.3.gz $RPM_BUILD_ROOT/usr/share/man/man3
install -m 544 chkbin $RPM_BUILD_ROOT/sbin
install -m 644 chkbin.8.gz $RPM_BUILD_ROOT/usr/share/man/man8
install -m 544 getappcore $RPM_BUILD_ROOT/sbin
install -m 644 getappcore.8.gz $RPM_BUILD_ROOT/usr/share/man/man8
install -m 544 analyzevmcore $RPM_BUILD_ROOT/sbin
install -m 644 analyzevmcore.8.gz $RPM_BUILD_ROOT/usr/share/man/man8
install -m 755 schealth $RPM_BUILD_ROOT/usr/bin
install -m 644 schealth.conf $RPM_BUILD_ROOT/etc
install -m 444 scplugin.rc $RPM_BUILD_ROOT/usr/lib/supportconfig/resources

%files
%defattr(-,root,root)
/sbin/supportconfig
/sbin/chkbin
/sbin/getappcore
/sbin/analyzevmcore
/usr/bin/schealth
/usr/lib/supportconfig
/usr/lib/supportconfig/resources
%doc /usr/share/man/man5/*
%doc /usr/share/man/man3/*
%doc /usr/share/man/man8/*
%config /etc/schealth.conf

%clean
rm -rf $RPM_BUILD_ROOT

%changelog -n supportutils
