OBSPACKAGE=supportutils
SVNDIRS=spec bin man config
VERSION=$(shell awk '/Version:/ { print $$2 }' spec/${OBSPACKAGE}.spec)
RELEASE=$(shell awk '/Release:/ { print $$2 }' spec/${OBSPACKAGE}.spec)
SRCDIR=$(OBSPACKAGE)-$(VERSION)
SRCFILE=$(SRCDIR).tar
BUILDDIR=/usr/src/packages

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
	@cp COPYING.GPLv2 $(SRCDIR)
	@tar cf $(SRCFILE) $(SRCDIR)/*
	@gzip -9f $(SRCFILE)
	@rm -rf $(SRCDIR)
	@mv -f $(SRCFILE).gz src

clean: uninstall
	@echo [clean]: Cleaning up make files
	@rm -rf $(OBSPACKAGE)*
	@for i in $(SVNDIRS); do rm -f $$i/*~; done
	@rm -f *~
	@rm -rf src Novell:NTS

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

obsetup:
	@echo [obsetup]: Setup OBS Novell:NTS/$(OBSPACKAGE)
	@rm -rf Novell:NTS
	@osc co Novell:NTS/$(OBSPACKAGE)

obs: dist
	@echo [obs]: Committing changes to OBS Novell:NTS/$(OBSPACKAGE)
	@osc up Novell:NTS/$(OBSPACKAGE)
	@osc del Novell:NTS/$(OBSPACKAGE)/*
	@osc ci -m "Removing old files before committing: $(OBSPACKAGE)-$(VERSION)-$(RELEASE)" Novell:NTS/$(OBSPACKAGE)
	@rm -f Novell:NTS/$(OBSPACKAGE)/*
	@cp spec/$(OBSPACKAGE).spec Novell:NTS/$(OBSPACKAGE)
	@cp src/$(SRCFILE).gz Novell:NTS/$(OBSPACKAGE)
	@osc add Novell:NTS/$(OBSPACKAGE)/*
	@osc up Novell:NTS/$(OBSPACKAGE)
	@osc ci -m "Committing to OBS: $(OBSPACKAGE)-$(VERSION)-$(RELEASE)" Novell:NTS/$(OBSPACKAGE)

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
	@echo ' obs        Builds the packages and checks files into OBS'
	@echo ' commit     Commits all changes to GIT'
	@echo ' push       Pushes commits to public GIT'
	@echo
	@ls -l ${LS_OPTIONS}
	@echo
	@echo GIT Status
	@git status --short
	@echo

