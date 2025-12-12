# Veritas.Engine

Pandoc-based conversion engine for transforming Markdown to LaTeX using the Veritas template.

## Usage

```bash
./Script/convert.sh input.md [output.tex]
```

## Components

| Directory | Purpose |
|-----------|---------|
| `Converter/` | Pandoc templates |
| `Pipeline/` | Build pipeline scripts |
| `Script/` | CLI conversion scripts |

## YAML Frontmatter

```yaml
---
title: Document Title
subtitle: Optional Subtitle
author: Author Name
date: December 2025
lang: en  # or de
chapterstyle: minimal  # classic, fancy, modern
---
```

## Dependencies

- Pandoc ≥ 2.0 (see `../Veritas.Pandoc/`)
- XeLaTeX
