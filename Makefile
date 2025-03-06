# Makefile,v
# Copyright (c) INRIA 2007-2017

TOP=.
include $(TOP)/config/Makefile.top

WD=$(shell pwd)
DESTDIR=

SYSDIRS= lorem_ipsum runtime bin

TESTDIRS= tests

all: sys
	set -e; for i in $(TESTDIRS); do cd $$i; $(MAKE) all; cd ..; done

sys:
	set -e; for i in $(SYSDIRS); do cd $$i; $(MAKE) all; cd ..; done

## NOTE WELL: not testing with MDX (b/c MDX is backlevel)
test: all
	set -e; for i in $(TESTDIRS); do cd $$i; $(MAKE) test; cd ..; done

META: sys
	$(JOINMETA) -rewrite lorem_ipsum_runtime:lorem_ipsum.runtime \
			-direct-include lorem_ipsum \
			-wrap-subdir runtime:runtime > META

install: META
	$(OCAMLFIND) remove lorem_ipsum || true
	$(OCAMLFIND) install lorem_ipsum META local-install/lib/*/*.*

uninstall:
	$(OCAMLFIND) remove lorem_ipsum || true

clean::
	set -e; for i in $(SYSDIRS) $(TESTDIRS); do cd $$i; $(MAKE) clean; cd ..; done
	rm -rf docs local-install $(BATCHTOP) META *.corrected

depend:
	set -e; for i in $(SYSDIRS) $(TESTDIRS); do cd $$i; $(MAKE) depend; cd ..; done
