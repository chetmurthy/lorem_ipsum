WD=$(shell pwd)
TOP=..
include $(TOP)/config/Makefile.sub

PACKAGES := $(PACKAGES),lorem_ipsum,ounit2,pa_ppx.utils,pa_ppx.testutils,pp-binary-ints

ML= \
	lorem_ipsum_test.ml \

ALLSRC=$(ML)
ALLPACKAGES=$(PACKAGES)

TESTS=lorem_ipsum_test.exe

all: $(TESTS) $(TESTEXE)

test:: all
	mkdir -p _build && ./lorem_ipsum_test.exe

lorem_ipsum_test.exe: lorem_ipsum_test.cmo
	$(LAUNCH) $(OCAMLFIND) ocamlc -linkall -linkpkg $(OCAMLCFLAGS) -package $(PACKAGES) -linkpkg -linkall -o $@ $<


clean::
	rm -rf *.cm* _build *.exe tmp
