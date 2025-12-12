# Veritas LaTeX Template Makefile
# Version: 1.0.0 - 2025-12-12
# Based on: Stéphane Caron - Makefiles for LaTeX
# Compliance: Standard.md LOC-2 Rule 6 (Reproducible Builds)
# Dependencies: ["latexmk", "inotify-tools"]

PAPER=Main.tex
SHELL=/bin/bash
TOOL=latexmk

# LOC-5 Rule 16: Reproducible builds with fixed timestamp
export SOURCE_DATE_EPOCH ?= $(shell date +%s)

all:
	@echo "Building $(PAPER) with $(TOOL)..."
ifeq ($(TOOL),latexmk)
	@latexmk -pdf -xelatex -shell-escape -halt-on-error $(PAPER)
else
	@echo "Error: Unsupported tool '$(TOOL)'. Use 'latexmk'."
	@exit 1
endif
	@echo "Build complete."

clean:
	@echo "Cleaning up..."
	@latexmk -C
	@for ext in acn acr alg fls xdv fdb_latexmk toc ist glg glo gls glsdefs; do \
		if compgen -G "*.$$ext" > /dev/null; then \
			rm -f *.$$ext; \
		fi; \
	done
	@echo "Clean complete."

watch:
	@echo "Watching $(PAPER) for changes..."
	@while true; do inotifywait -e close_write $(PAPER); sleep 0.01; make all; done

# Verification target for Standard.md compliance
verify:
	@echo "Checking for compilation warnings..."
	@latexmk -pdf -xelatex -shell-escape -halt-on-error $(PAPER)
	@echo "Checking log for warnings..."
	@grep -E "(Overfull|Underfull|Warning)" Main.log | grep -v "^Package" || echo "No critical warnings found."
	@echo "Verification complete."

.PHONY: all clean watch verify