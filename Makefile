## MAKEFILE FOR MANUSCRIPT STARTER
##
## Put this Makefile in your project directory---i.e., the directory
## containing the paper you are writing. Assuming you are using the
## rest of the toolchain here, you can use it to create .html, .tex,
## and .pdf output files (complete with bibliography, if present) from
## your markdown file. 
## -	Change the paths at the top of the file as needed.
## -	Using `make` without arguments will generate html, tex, and pdf 
## 	output files from all of the files with the designated markdown
##	extension. The default is `.md` but you can change this. 
## -	You can specify an output format with `make tex`, `make pdf`,  
## - 	`make html`, or `make docx`.
## -	Doing `make clean` will remove all the .tex, .html, .pdf, and .docx files 
## 	in your working directory. Make sure you do not have files in these
##	formats that you want to keep!
## -    Pandoc and related tools can be redirected using PDBINS, which is useful
##      if you need to recompile any pandoc-related binary due to library
##      compatibility issues 
## 
##
##


## System init
PDBINS=~/.local/bin

## All Rmarkdown files in the working directory
RSRC = $(wildcard *.Rmd)

## Markdown extension (e.g. md, markdown, mdown, Rmd).
MEXT = md

## All markdown files in the working directory
SRC = $(wildcard *.$(MEXT))

## Location of templates, stylesheets et al.
PREFIX = lib

## LaTeX template
LATEXTEMPLATE = rmd-xelatex-nicer-ms-lessajs.latex

## MS Word template
DOCXTEMPLATE = rmd-minion-reference.docx

## Pandoc options to use for all document types
##OPTIONS = markdown+simple_tables+table_captions+yaml_metadata_block+smart
OPTIONS = markdown+simple_tables+table_captions+yaml_metadata_block

## LITERATURE REFERENCES: CITEPROC + PREAMBLE
##
## Location of your working bibliography file
BIB = /home/torkildl/Dropbox/Literature/thl-main-library.bib
##
## CSL stylesheet (located in the csl folder of the PREFIX directory).
CSLDIR = /home/torkildl/Dropbox/Literature/csl-files
CSL = demography
##
PREAMBLE = --filter $(PDBINS)/pandoc-citeproc-preamble  -M citeproc-preamble=$(PREFIX)/citeproc-preamble/default.latex
CITEPROC = --filter $(PDBINS)/pandoc-citeproc --csl=$(CSLDIR)/$(CSL).csl --bibliography=$(BIB)

### RECIPES
###
## Convert all Rmd to md
MD=$(RSRC:.Rmd=.md)

## Build PDFs from md's
PDFS=$(SRC:.md=.pdf)

## Build HTML from md's
HTML=$(SRC:.md=.html)

## Build LaTeX source from md's
TEX=$(SRC:.md=.tex)

## Build docx from mdæs
DOCX=$(SRC:.md=.docx)

## Standard usage
default:	$(MD) $(HTML)

## Specific recipes
md:	$(MD)
pdf:	md $(PDFS)
html:	md $(HTML)
tex:	md $(TEX)
docx:	md $(DOCX)

%.md:	%.Rmd
	R --slave -e "knitr::knit('$<')"

%.html:	%.md
	$(PDBINS)/pandoc -r $(OPTIONS) -w html  --template=$(PREFIX)/templates/html/html.template --css=$(PREFIX)/marked/kultiad-serif.css  $(CITEPROC) -o $@ $<

%.tex:	%.md
	$(PDBINS)/pandoc -r $(OPTIONS) -w latex -s  --pdf-engine=xelatex --template=$(PREFIX)/templates/latex/$(LATEXTEMPLATE) $(CITEPROC) $(PREAMBLE) -o $@ $<


%.pdf:	%.md
	$(PDBINS)/pandoc -r $(OPTIONS) -s --pdf-engine=xelatex --template=$(PREFIX)/templates/latex/$(LATEXTEMPLATE) $(CITEPROC) $(PREAMBLE) -o $@ $<


%.docx: %.md
	$(PDBINS)/pandoc -r $(OPTIONS) -w docx  $(CITEPROC) --reference-doc=$(PREFIX)/templates/docx/$(DOCXTEMPLATE) -o $@ $<

view:	pdf
	evince *.pdf

clean:
	rm -f *.pdf *.tex *.docx

