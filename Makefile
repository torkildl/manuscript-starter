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


## All Rmarkdown files in the working directory
RSRC = $(wildcard *.Rmd)

## Markdown extension (e.g. md, markdown, mdown, Rmd).
MEXT = md

## All markdown files in the working directory
SRC = $(wildcard *.$(MEXT))

## Location of Pandoc support files.
PREFIX = lib

## Location of your working bibliography file
BIB = /home/torkildl/Dropbox/Literature/thl-main-library.bib

## CSL stylesheet (located in the csl folder of the PREFIX directory).
CSLDIR = /home/torkildl/Dropbox/Literature/csl-files
CSL = demography

## Pandoc options to use for all document types
##OPTIONS = markdown+simple_tables+table_captions+yaml_metadata_block+smart
OPTIONS = markdown+simple_tables+table_captions+yaml_metadata_block

## LaTeX template
LATEXTEMPLATE = rmd-xelatex-nicer-ms.latex

## MS Word template
DOCXTEMPLATE = $(PREFIX)/templates/docx/rmd-minion-reference.docx

MD=$(RSRC:.Rmd=.md)

PDFS=$(SRC:.md=.pdf)
HTML=$(SRC:.md=.html)
TEX=$(SRC:.md=.tex)
DOCX=$(SRC:.md=.docx)

all:	$(MD) $(PDFS) $(HTML) $(TEX) $(DOCX)

md:	clean $(MD)
pdf:	clean $(PDFS)
html:	clean $(HTML)
tex:	clean $(TEX)
docx:	clean $(DOCX)

%.md:	%.Rmd
	R --slave -e "knitr::knit('$<')"

%.html:	%.md
	pandoc -r $(OPTIONS) -w html  --template=$(PREFIX)/templates/html/html.template --css=$(PREFIX)/marked/kultiad-serif.css --filter pandoc-citeproc --csl=$(CSLDIR)/$(CSL).csl --bibliography=$(BIB) -o $@ $<

%.tex:	%.md
	pandoc -r $(OPTIONS) -w latex -s  --latex-engine=xelatex --template=$(PREFIX)/templates/latex/$(LATEXTEMPLATE) --filter pandoc-citeproc --csl=$(CSLDIR)/$(CSL).csl --bibliography=$(BIB) -o $@ $<


%.pdf:	%.md
	pandoc -r $(OPTIONS) -s --latex-engine=xelatex --template=$(PREFIX)/templates/latex/$(LATEXTEMPLATE) --filter pandoc-citeproc --csl=$(CSLDIR)/$(CSL).csl --bibliography=$(BIB) -o $@ $<


%.docx: %.md
	pandoc -r $(OPTIONS) -w docx  --filter pandoc-citeproc --csl=$(CSLDIR)/$(CSL).csl --bibliography=$(BIB) --reference-doc=$(DOCXTEMPLATE) -o $@ $<

clean:
	rm -f *.html *.pdf *.tex *.docx

