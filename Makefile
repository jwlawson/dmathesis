NAME = main
PTX = pdflatex
LTX = latex
BIBTEX = bibtex

SUBDIRS = 
_SECTIONS = $(wildcard *.tex) $(foreach dir,$(SUBDIRS),$(wildcard $(dir)/*.tex))
_PICS = $(wildcard img/*.tex)
PICS = $(_PICS:.tex=.pdf)
EPSS = $(_PICS:.tex=.eps)
PIC_DIR = img/
PIC_TMP = img/build/
BUILD_DIR = build
MAIN = $(NAME).pdf
BIB_FILE = $(word 1, $(wildcard *.bib))
CLS_FILE = dmathesis.cls
ifneq (,$(wildcard .git))
	GIT_VARS = git.gen
endif
ifneq (,$(shell which texcount))
	WC_VARS = wc.gen
endif
PKGS = $(wildcard *.sty)

TXFLAGS =  --synctex=1 -output-directory $(BUILD_DIR)

RERUN = "(There were undefined references|Rerun to get (cross-references|the bars|outlines) right)"
RERUNBIB = "No file.*\.bbl|Citation.*undefined"
TIKZ_PRE = '\documentclass{standalone}\usepackage{booktabs}\usepackage{tkz-euclide}\usetkzobj{all}\usetikzlibrary{positioning}\usetikzlibrary{decorations.pathmorphing}\DeclareFontFamily{U}{mathx}{\hyphenchar\font45}\DeclareFontShape{U}{mathx}{m}{n}{<-> mathx10}{}\DeclareSymbolFont{mathx}{U}{mathx}{m}{n}\DeclareMathAccent{\widebar}{0}{mathx}{"73}\usepackage{amsmath}\begin{document}\input{'
TIKZ_POST = '}\end{document}'

COPY = if test -r $(JOB).toc; then cp $(JOB).toc $(JOB).toc.bak; fi 
RM = rm -f

define run-pdflatex
	$(COPY);$(PTX) $(TXFLAGS) $<
	egrep -q $(RERUNBIB) $(JOB).log && (pushd $(BUILD_DIR);$(BIBTEX) $(basename $<);popd;$(COPY);$(PTX) $(TXFLAGS) $<) ; true
	egrep -q $(RERUN) $(JOB).log && ($(COPY);$(PTX) $(TXFLAGS) $<) >/dev/null; true
	egrep -q $(RERUNBIB) $(JOB).log && (pushd $(BUILD_DIR);$(BIBTEX) $(JOB);popd;$(COPY);$(PTX) $(TXFLAGS) $<) ; true
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

$(PIC_DIR)%.pdf: $(PIC_DIR)%.tex
	$(PTX) -jobname $(basename $(@F)) -output-directory $(PIC_TMP) $(TIKZ_PRE)$<$(TIKZ_POST)
	pdfcrop $(PIC_TMP)$(basename $(@F)).pdf
	mv $(PIC_TMP)$(basename $(@F))-crop.pdf $@

$(PIC_DIR)%.eps: $(PIC_DIR)%.tex $(PIC_DIR)%.pdf
	pdftops -eps $(PIC_DIR)$(basename $(@F)).pdf

$(PICS): | $(PIC_TMP)

$(PIC_TMP):
	mkdir -p $(PIC_TMP)

$(MAIN): | $(SUBDIRS)
$(MAIN): | $(BUILD_DIR)
$(MAIN): $(NAME).tex $(_SECTIONS) $(PICS) $(EPSS) $(BUILD_DIR)/$(BIB_FILE) $(GIT_VARS) $(WC_VARS) $(PKGS) $(CLS_FILE)
	$(eval JOB := $(BUILD_DIR)/$(NAME))
	@$(run-pdflatex)
	mv $(BUILD_DIR)/$(NAME).pdf $@

$(GIT_VARS): .git/logs/HEAD
	echo "% Automatically generated git variables" > $(GIT_VARS)
	git log -1 --format="format:\\gdef\\GITAbrHash{%h}\\gdef\\GITAuthorDate{%ad}\\gdef\\GITAuthorName{%an}" >> $(GIT_VARS)
	echo "\\gdef\\GITBranch{`git branch | grep '*' | awk '{print $$2}'`}" >> $(GIT_VARS)

$(WC_VARS): $(NAME).tex $(_SECTIONS)
	echo "% Automatically generated texcount variables" > $(WC_VARS)
	echo "\\gdef\\WCBrief{`texcount -q -merge -brief $(NAME).tex | awk '{print $$1, $$2}'`}" >> $(WC_VARS)

$(BUILD_DIR)/$(BIB_FILE): $(BIB_FILE) | $(BUILD_DIR)
	cp $< $@

clean:
	$(RM) $(BUILD_DIR)/*.{log,aux,bbl,blg,ilg,toc,lof,lot,idx,ind,snm,out,nav,synctex.gz,bak,xml,bib} *~
	$(RM) $(GIT_VARS) $(WC_VARS)
	$(RM) -r $(PIC_TMP)
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done

cleanpdf: clean
	$(RM) $(BUILD_DIR)/*.{pdf,ps,dvi}
	$(RM) $(PICS)
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir cleanpdf; \
	done

