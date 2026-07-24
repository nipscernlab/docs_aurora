SPHINXBUILD ?= .venv/Scripts/sphinx-build.exe
SOURCEDIR = source
BUILDDIR = build

.PHONY: html html-only pdf clean
html: pdf
	$(SPHINXBUILD) -W --keep-going -b html $(SOURCEDIR) $(BUILDDIR)/html

html-only:
	$(SPHINXBUILD) -W --keep-going -b html $(SOURCEDIR) $(BUILDDIR)/html

pdf:
	powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts/build-pdf.ps1

clean:
	$(SPHINXBUILD) -M clean $(SOURCEDIR) $(BUILDDIR)
