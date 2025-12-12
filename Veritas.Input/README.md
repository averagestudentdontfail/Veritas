# Veritas.Input

Source markdown files for the Veritas document pipeline.

## Usage

Place `.md` files here with YAML frontmatter:

```yaml
---
title: "Document Title"
author: "Author Name"
date: "December 2025"
lang: en
chapterstyle: minimal
---

# Your Content

Write your document in markdown...
```

## Build

```bash
# Build all documents
./Veritas.Engine/Script/build.sh

# Build specific document
./Veritas.Engine/Script/build.sh document.md
```

Output PDFs appear in `Veritas.Output/`.
