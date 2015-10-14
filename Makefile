OBSPACKAGE=supportutils
SVNDIRS=spec bin man
VERSION=$(shell awk '/Version:/ { print $$2 }' spec/${OBSPACKAGE}.spec)
RELEASE=$(shell awk '/Release:/ { print $$2 }' spec/${OBSPACKAGE}.spec)
SRCDIR=$(OBSPACKAGE)-$(VERSION)
SRCFILE=$(SRCDIR).tar
BUILDDIR=/home/jrecord/rpmbuild

default: build

install: dist
	@echo [install]: Installing source files into build directory
	@cp src/$(SRCFILE).gz $(BUILDDIR)/SOURCES
	@cp spec/$(OBSPACKAGE).spec $(BUILDDIR)/SPECS

uninstall:
	@echo [uninstall]: Uninstalling from build directory
	@rm -rf $(BUILDDIR)/SOURCES/$(SRCFILE).gz
	@rm -rf $(BUILDDIR)/SPECS/$(OBSPACKAGE).spec
	@rm -rf $(BUILDDIR)/BUILD/$(SRCDIR)
	@rm -f $(BUILDDIR)/SRPMS/$(OBSPACKAGE)-*.src.rpm
	@rm -f $(BUILDDIR)/RPMS/noarch/$(OBSPACKAGE)-*.noarch.rpm

dist:
	@echo [dist]: Creating distribution source tarball
	@mkdir -p src
	@mkdir -p $(SRCDIR)
	@for i in $(SVNDIRS); do cp -a $$i $(SRCDIR); done
	@tar cf $(SRCFILE) $(SRCDIR)/*
	@gzip -9f $(SRCFILE)
	@rm -rf $(SRCDIR)
	@mv -f $(SRCFILE).gz src

clean: uninstall
	@echo [clean]: Cleaning up make files
	@rm -rf $(OBSPACKAGE)*
	@for i in $(SVNDIRS); do rm -f $$i/*~; done
	@rm -f *~
	@rm -rf src

build: clean install
	@echo [build]: Building RPM package
	@rpmbuild -ba $(BUILDDIR)/SPECS/$(OBSPACKAGE).spec
	@cp $(BUILDDIR)/SRPMS/$(OBSPACKAGE)-$(VERSION)-$(RELEASE).src.rpm .
	@cp $(BUILDDIR)/RPMS/noarch/$(OBSPACKAGE)-$(VERSION)-$(RELEASE).noarch.rpm .
	@echo
	@ls -al ${LS_OPTIONS}
	@echo
	@git status --short
	@echo

obsetup: obclean
	@echo [obsetup]: Setup IBS SUSE:SLE-11-SP3:Update:Test/$(OBSPACKAGE)
	@osc -A 'https://api.suse.de' bco SUSE:SLE-11-SP3:Update:Test/$(OBSPACKAGE) &>/dev/null

obclean: clean
	@echo [obclean]: Cleaning IBS SUSE:SLE-11-SP3:Update:Test
	@rm -rf home:jrecord:branches:SUSE:SLE-11-SP3:Update:Test

obs: dist
	@echo [obs]: Preparing IBS SUSE:SLE-11-SP3:Update:Test/$(OBSPACKAGE) for submit request
	@osc -A 'https://api.suse.de/' up home:jrecord:branches:SUSE:SLE-11-SP3:Update:Test/$(OBSPACKAGE) &>/dev/null
	@cp spec/* home:jrecord:branches:SUSE:SLE-11-SP3:Update:Test/$(OBSPACKAGE)
	@cp src/$(SRCFILE).gz home:jrecord:branches:SUSE:SLE-11-SP3:Update:Test/$(OBSPACKAGE)

commit: build
	@echo [commit]: Committing changes to GIT
	@git commit -a -m "Committing Source: $(OBSPACKAGE)-$(VERSION)-$(RELEASE)"

push:
	@echo [push]: Pushing changes to GIT
	@git push -u origin master

help:
	@clear
	@echo Make options for package: $(OBSPACKAGE)
	@echo make [TARGETS]
	@echo
	@echo TARGETS
	@echo ' clean      Uninstalls build directory and cleans up build files'
	@echo ' install    Installs source files to the build directory'
	@echo ' uninstall  Removes files from the build directory'
	@echo ' dist       Creates the src directory and distribution tar ball'
	@echo ' build      Builds the RPM packages (default)'
	@echo ' obsetup    Checks out the OBS repository for this package'
	@echo ' obclean    Removes the local OBS repository files'
	@echo ' obs        Copys source and spec files for OBS change, does not commit'
	@echo ' commit     Commits all changes to GIT'
	@echo ' push       Pushes commits to public GIT'
	@echo
	@ls -l ${LS_OPTIONS}
	@echo
	@echo GIT Status
	@git status --short
	@echo

