# Veritas

A templated LaTeX engine with markdown conversion support.

## Components

| Component | Description |
|-----------|-------------|
| `Veritas.Input/` | Source markdown files |
| `Veritas.Output/` | Generated PDF documents |
| `Veritas.Engine/` | Pandoc-based conversion pipeline |
| `Veritas.Class/` | LaTeX document class (.cls, .sty) |
| `Veritas.Pandoc/` | Pandoc source (local) |
| `Veritas.LyX/` | LyX source (local) |
| `Veritas.Governance/` | Coding standards |

## Quick Start

1. Add `.md` files to `Veritas.Input/`
2. Run: `./Veritas.Engine/Script/build.sh`
3. Find PDFs in `Veritas.Output/`

## Markdown Format

```yaml
---
title: "Document Title"
author: "Author Name"
date: "December 2025"
lang: en
chapterstyle: minimal
---

# Content

Your markdown content with $LaTeX$ math support.
```

## Features

- **Typography**: Minion Pro with optical variants
- **Mathematics**: amsthm theorem environments
- **Chapter Styles**: Minimal, Classic, Fancy, Modern
- **Languages**: English, German

## Requirements

- XeLaTeX (TeX Live)
- Pandoc ≥ 2.0

## License

LPPL 1.3c
