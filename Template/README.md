# Veritas LaTeX Template

**Version:** 1.0.0  
**Date:** December 2025  
**License:** LPPL 1.3c  
**Compliance:** Standard.md (LOC-1 through LOC-5)

## Overview

Veritas is a general-purpose academic LaTeX template for theses, dissertations, and technical reports. It provides a clean, professional design with comprehensive configuration options while maintaining strict compliance with documented coding standards.

## Features

- **Typography**: Minion Pro serif with optical size variants (Display, Subhead, Semibold)
- **Chapter Styles**: Classic, Fancy, and Modern heading designs
- **Media Modes**: Screen (continuous) and Paper (with blank pages for binding)
- **Internationalisation**: English and Portuguese language support
- **Bibliography**: Author-year citations via biblatex/biber
- **Code Highlighting**: Pygments-based syntax highlighting via minted

## Quick Start

```latex
\documentclass[
    language=english,
    chapterstyle=fancy,
    media=screen
]{Veritas}

\input{Metadata/Metadata}

\begin{document}
\include{Chapters/01-Introduction}
\printbibliography
\end{document}
```

## Build Instructions

```bash
# Single build
make

# Watch for changes
make watch

# Clean auxiliary files
make clean

# Verify Standard.md compliance
make verify
```

**Requirements**: XeLaTeX, latexmk, biber, and optionally minted (requires Pygments).

## Class Options

| Option | Values | Default | Description |
|--------|--------|---------|-------------|
| `language` | english, portuguese | english | Document language |
| `chapterstyle` | classic, fancy, modern | classic | Chapter heading style |
| `coverstyle` | classic, bw, fancy | classic | Cover page style |
| `media` | screen, paper | paper | Output media (blank pages) |
| `docstage` | working, final | working | Draft watermark |
| `doctype` | thesis, report, article | thesis | Document type |
| `bookprint` | true, false | false | Asymmetric margins for binding |
| `aiack` | true, false | true | AI acknowledgement section |
| `linkcolor` | any xcolor | black | Hyperlink color |

## Directory Structure

```
Template/
├── Main.tex                    # Primary document
├── Veritas.cls                 # Document class
├── Veritas.ist                 # Glossary style
├── Makefile                    # Build automation
├── Configurations/             # Modular settings
│   ├── 00-Fonts.sty           # Typography (Bringhurst)
│   ├── 01-Colors.sty          # Color system (Itten, WCAG)
│   ├── 02-Margins.sty         # Page geometry (Tschichold)
│   ├── 03-References.sty      # Bibliography (Chicago)
│   ├── 04-Headers.sty         # Page headers
│   ├── 05-Contents.sty        # Table of contents
│   ├── 06-Glossary.sty        # Terminology (ISO 704)
│   ├── 07-Chapters.sty        # Chapter formatting
│   ├── 08-Tables.sty          # Table design (Tufte)
│   ├── 09-Code.sty            # Code listings (Knuth)
│   ├── 10-Macros.sty          # Semantic commands (Lamport)
│   ├── 11-Metadata.sty        # PDF metadata (Dublin Core)
│   └── 12-Floats.sty          # Float placement (LaTeX Companion)
├── Chapters/                   # Main content
├── Matter/                     # Front/back matter
├── Bibliography/               # .bib files
├── Figures/                    # Images
└── Assets/                     # Template assets
```

## Standard.md Compliance

This template adheres to the Veritas LaTeX Coding Standard:

| Level | Focus | Implementation |
|-------|-------|---------------|
| LOC-1 | Language Compliance | LaTeX2e, no deprecated syntax |
| LOC-2 | Predictable Compilation | Explicit float placement [htbp] |
| LOC-3 | Defensive Authoring | Package guards, `\PackageError` |
| LOC-4 | Document Clarity | Semantic commands, separation of concerns |
| LOC-5 | Production Assurance | Reproducible builds, version metadata |

## First-Principles Design

Each configuration module documents its theoretical basis:

- **Typography**: Bringhurst's *Elements of Typographic Style*
- **Page Layout**: Tschichold's *The Form of the Book*
- **Color**: Itten's *The Art of Color*, WCAG accessibility
- **Tables**: Tufte's *Visual Display of Quantitative Information*
- **Citations**: Chicago Manual of Style, APA 7th Edition
- **Code**: Knuth's Literate Programming

## Credits

Based on [IPLeiria Thesis](https://github.com/joseareia/ipleiria-thesis) by José Areia.  
Refactored for general academic use with Standard.md compliance.

## License

Released under the [LaTeX Project Public License v1.3c](https://www.latex-project.org/lppl/lppl-1-3c/).
