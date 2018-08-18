### Makefile
# Author: Alessandra Gorla alessandra.gorla@imdea.org	

# Basic makefile for compiling LaTeX documents.

# Targets:
#
#    default   : compiles the document to a PDF file
#
#    clean     : removes the temporary files, but keeps the final PDF file
#
#    cleanAll  : removes all temporary files and the generated PDF file
#
#    local-diff.pdf: generates and opens a PDF file visualizing the
#     		local changes. You may want to use this before pushing
#     		to reviw your contributions.
#
#    my-last-commit-diff.pdf: generates and opens a PDF file
#     		visualizing the changes since you last contributed to
#     		the paper. You may want to use this to check the
#     		changes of your collaborators before editing the paper.

### !!! BEGIN EDIT AREA !!!
### Variable defining the main .tex file. Edit this if it is not
### called paper.tex
PAPER = paper
### !!! END EDIT AREA !!!


default: $(PAPER).pdf

### File Types (for dependancies)
TEX_FILES = $(shell find . -name '*.tex' -or -name '*.sty' -or -name '*.cls')
IMG_FILES = $(shell find . -path '*.jpg' -or -path '*.png' -or \( -iname "*.pdf" ! -iname "$(PAPER).pdf" \) )

### build PDF if any tex, image or bib file changed. 
$(PAPER).pdf: $(TEX_FILES) $(IMG_FILES) bib-update
	latexmk -pdf $(PAPER).tex

### use the imdea-se-bib repository for the bibliography.  See
### https://gitlab.software.imdea.org/alessandra.gorla/imdea-se-bib
### for more details.
export BIBINPUTS ?= .:bib
bib:
ifdef IMDEASEBIB
	ln -s ${IMDEASEBIB} $@
else
	git clone https://gitlab.software.imdea.org/alessandra.gorla/imdea-se-bib.git $@
endif

.PHONY: bib-update
### To skip the bib update taks invoke make as:  make NOGIT=1 ...
bib-update: bib
ifndef NOGIT
	-(cd bib && git pull && make)
endif


### Diff targets with rsc-latexdiff

## Check that rcs-latexdiff is installed
RCS_LATEX := $(shell command -v rcs-latexdiff 2> /dev/null)
check-rcs-latexdiff:
ifndef RCS_LATEX
    $(error "rcs-latexdiff is not available. Please install it here: https://github.com/driquet/rcs-latexdiff")
endif

## Display the latexdiff'd PDF of the current working version of the
## paper compared to the HEAD of the repository.
local-diff.pdf: check-rcs-latexdiff
	rcs-latexdiff $(PAPER).tex HEAD --output local-diff

MY_LAST_COMMIT = $(shell git log --author="$(git config user.name)" |	\
	head -n1 | cut -d ' ' -f 2)

## Display the latexdiff'd PDF of the current working version of the
## paper compared to the the most recent commit of the user
my-last-commit-diff.pdf: check-rcs-latexdiff
	rcs-latexdiff $(PAPER).tex $(MY_LAST_COMMIT) --output my-last-commit-diff


#### Clean targets
clean:
	rm -f *.bbl
	rm -f *.aux
	rm -f *.blg
	rm -f *.bbl
	rm -f *.latexmk
	rm -f *.fls
	rm -f *.log
	rm -f *_flymake*
	rm -f *_latexmk

cleanAll: clean
	rm -rf $(PAPER).pdf
