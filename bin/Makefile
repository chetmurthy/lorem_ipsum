WD=$(shell pwd)
TOP=..
include $(TOP)/config/Makefile.sub

PACKAGES := $(PACKAGES),lorem_ipsum,ounit2,pa_ppx.utils,pa_ppx.testutils,pp-binary-ints,rresult,bos,markup

ML= \
	lorem_ipsum.ml \

ALLSRC=$(ML)
ALLPACKAGES=$(PACKAGES)

EXE=\
	lorem_ipsum.exe \


all: $(EXE)

%.exe: %.cmo
	$(LAUNCH) $(OCAMLFIND) ocamlc -linkall -linkpkg $(OCAMLCFLAGS) -package $(PACKAGES) -linkpkg -linkall -o $@ $<

clean::
	rm -rf _build *.exe
