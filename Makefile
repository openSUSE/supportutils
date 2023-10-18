OBSPACKAGE=supportutils
SVNDIRS=spec bin man
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
	@tar cf $(SRCFILE) $(SRCDIR)/*
	@gzip -9f $(SRCFILE)
	@rm -rf $(SRCDIR)
	@mv -f $(SRCFILE).gz src

clean: uninstall obclean
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
	@echo
	@ls -l ${LS_OPTIONS}
	@echo
	@echo GIT Status
	@git status --short
	@echo

