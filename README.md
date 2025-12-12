# Veritas

A templated LaTeX engine with markdown conversion support.

## Components

| Component | Description |
|-----------|-------------|
| `Veritas.Engine/` | Pandoc-based markdown→LaTeX conversion |
| `Veritas.Class/` | Core LaTeX template (.cls, .sty modules) |
| `Veritas.Document/` | Document collections (Article, Assignment, Thesis) |
| `Veritas.LyX/` | LyX WYSIWYG frontend integration |
| `Veritas.Governance/` | Coding standards and compliance docs |

## Quick Start

### From LaTeX
```bash
cd Veritas.Class
make
```

### From Markdown
```bash
./Veritas.Engine/Script/convert.sh input.md output.tex
cd Veritas.Class && xelatex output.tex
```

### With LyX
See `Veritas.LyX/README.md` for setup instructions.

## Features

- **Typography**: Minion Pro with optical variants
- **Mathematics**: amsthm theorem environments
- **Chapter Styles**: Minimal, Classic, Fancy, Modern
- **Languages**: English, German
- **Conversion**: Markdown → LaTeX via Pandoc

## Requirements

- XeLaTeX (TeX Live or MiKTeX)
- Pandoc ≥ 2.0 (for markdown conversion)
- Biber (for bibliography)

## License

LPPL 1.3c
