NAME = main
PTX = pdflatex
LTX = latex
BIBTEX = bibtex
SHELL := /bin/bash

SUBDIRS = 
_SECTIONS = $(wildcard *.tex) $(foreach dir,$(SUBDIRS),$(wildcard $(dir)/*.tex))
BUILD_DIR = build
MAIN = $(NAME).pdf
BIB_FILE = $(word 1, $(wildcard *.bib))
CLS_FILE = dmathesis.cls
PKGS = $(wildcard *.sty)

TXFLAGS =  --synctex=1 -output-directory $(BUILD_DIR)

RERUN = "(There were undefined references|Rerun to get (cross-references|the bars|outlines) right)"
RERUNBIB = "No file.*\.bbl|Citation.*undefined|Empty bibliography"

COPY = if test -r $(JOB).toc; then cp $(JOB).toc $(JOB).toc.bak; fi 
RM = rm -f

define run-pdflatex
	$(COPY);$(PTX) $(TXFLAGS) $<
	egrep -q $(RERUNBIB) $(JOB).log && (pushd $(BUILD_DIR);$(BIBTEX) $(basename $<);popd;$(COPY);$(PTX) $(TXFLAGS) $<) ; true
	egrep -q $(RERUN) $(JOB).log && ($(COPY);$(PTX) $(TXFLAGS) $<) >/dev/null; true
	egrep -q $(RERUNBIB) $(JOB).log && (pushd $(BUILD_DIR);$(BIBTEX) $(basename $<);popd;$(COPY);$(PTX) $(TXFLAGS) $<) ; true
	if cmp -s $(JOB).toc $(JOB).toc.bak; then true ;else $(PTX) $(TXFLAGS) $< ; fi
	$(RM) $(JOB).toc.bak
	egrep -i "(Reference|Citation).*undefined" $(JOB).log ; true
endef

.PHONY: all clean cleanpdf subdirs $(SUBDIRS)

all: $(MAIN)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(MAIN): | $(SUBDIRS)
$(MAIN): | $(BUILD_DIR)
$(MAIN): $(NAME).tex $(_SECTIONS) $(BUILD_DIR)/$(BIB_FILE) $(PKGS) $(CLS_FILE)
	$(eval JOB := $(BUILD_DIR)/$(NAME))
	@$(run-pdflatex)
	mv $(BUILD_DIR)/$(NAME).pdf $@

$(BUILD_DIR)/$(BIB_FILE): $(BIB_FILE) | $(BUILD_DIR)
	cp $< $@

clean:
	$(RM) $(BUILD_DIR)/*
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done

cleanpdf: clean
	$(RM) -r $(BUILD_DIR)/*
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir cleanpdf; \
	done

