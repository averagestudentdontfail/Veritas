# Veritas LaTeX Template

**Version:** 2.0.0  
**Date:** December 2025  
**License:** LPPL 1.3c  
**Compliance:** Standard.md (LOC-1 through LOC-5)

## Overview

Veritas is a general-purpose LaTeX template for articles, theses, and technical documents. It provides professional typography with comprehensive mathematics support while maintaining strict coding standards.

## Features

- **Typography**: Minion Pro with optical variants (Display, Subhead, Semibold)
- **Mathematics**: amsthm environments (theorem, lemma, proof, etc.)
- **Chapter Styles**: Minimal, Classic, Fancy, Modern
- **Languages**: English, German
- **Media Modes**: Screen (default), Paper (with binding margins)
- **LyX Integration**: Optional WYSIWYG frontend

## Quick Start

```latex
\documentclass[
    language=english,
    chapterstyle=minimal,
    media=screen
]{Veritas}

\Title{My Document}
\FirstAuthor{Author Name}
\Date{December 2025}

\input{Metadata/Metadata}

\begin{document}
\include{Matter/Title-Page}
% Your content here
\end{document}
```

## Build

```bash
make        # Build PDF
make clean  # Remove auxiliary files
make watch  # Auto-rebuild on changes
```

**Requirements**: XeLaTeX, latexmk, biber

## Class Options

| Option | Values | Default | Description |
|--------|--------|---------|-------------|
| `language` | english, german | english | Document language |
| `chapterstyle` | minimal, classic, fancy, modern | minimal | Chapter heading style |
| `media` | screen, paper | screen | Output media |
| `docstage` | working, final | final | Draft watermark |
| `doctype` | article, report, thesis | article | Document type |
| `bookprint` | true, false | false | Physical binding margins |
| `cover` | true, false | false | Include cover page |
| `linkcolor` | any xcolor | black | Hyperlink color |

## Mathematics

Built-in theorem environments:

```latex
\begin{theorem}[Optional Name]
  Statement of the theorem.
\end{theorem}

\begin{proof}
  The proof follows...
\end{proof}
```

Available environments: `theorem`, `lemma`, `proposition`, `corollary`, `conjecture`, `definition`, `example`, `axiom`, `remark`, `note`, `proof`

Convenient notation:
- Number sets: `\N`, `\Z`, `\Q`, `\R`, `\C`
- Delimiters: `\abs{x}`, `\norm{x}`, `\inner{x,y}`, `\floor{x}`, `\ceil{x}`
- Operators: `\E`, `\Prob`, `\Var`, `\Cov`, `\argmax`, `\argmin`

## LyX Integration

For WYSIWYG editing:

1. Copy `LyX/Veritas.layout` to your LyX layouts directory:
   - Linux/Mac: `~/.lyx/layouts/`
   - Windows: `C:\Users\<user>\AppData\Roaming\lyx2.x\layouts\`
2. In LyX: **Tools → Reconfigure**, then restart
3. **Document → Settings → Document Class → Veritas**

## Directory Structure

```
Template/
├── Main.tex                    # Primary document
├── Veritas.cls                 # Document class
├── Makefile                    # Build automation
├── LyX/                        # LyX integration
│   └── Veritas.layout
├── Configurations/             # Modular settings
│   ├── 00-Fonts.sty           # Typography
│   ├── 01-Colors.sty          # Color system
│   ├── 02-Margins.sty         # Page geometry
│   ├── ...
│   └── 13-Mathematics.sty     # Theorem environments
├── Matter/                     # Title/back pages
├── Chapters/                   # Content
└── Bibliography/               # References
```

## Book Printing

For physical binding, derived from Williamson (1983):

```latex
\documentclass[bookprint=true, media=paper]{Veritas}
```

This applies:
- 25mm inner margin (gutter clearance)
- 37.5mm outer margin (1.5× ratio for thumb grip)
- 6mm binding offset
- Two-sided page layout

## Credits

Based on [IPLeiria Thesis](https://github.com/joseareia/ipleiria-thesis) by José Areia.

## License

[LaTeX Project Public License v1.3c](https://www.latex-project.org/lppl/lppl-1-3c/)
