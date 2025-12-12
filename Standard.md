# LaTeX Coding Standard

**Version:** 1.0
**Date:** December 2025
**Based on:** First Principles of TeX & CTAN Package Guidelines
**Applicability:** Academic Publication & Technical Documentation Systems

## Table of Contents
1. Rule Summary
2. Introduction
3. Scope
4. Conventions
5. Levels of Compliance
6. LOC-1: Language Compliance
7. LOC-2: Predictable Compilation
8. LOC-3: Defensive Authoring
9. LOC-4: Document Clarity
10. LOC-5: Production Assurance
11. References

## 1. Rule Summary

### Language Compliance
1. **Conform to LaTeX2e Standard**: Do not use deprecated LaTeX 2.09 syntax or rely on engine-specific primitives without fallback.
2. **Zero Warnings**: Compile with `-halt-on-error` and `-file-line-error`; eliminate all overfull/underfull box warnings.

### Predictable Compilation
3. **Bounded Loops**: All `\loop` or recursive macros must have explicit termination conditions.
4. **No Fragile Recursion**: Avoid unbounded `\expandafter` chains; use `expl3` expansion control.
5. **Explicit Float Control**: Do not rely on implicit float placement; use explicit `[htbp!]` specifiers.
6. **Deterministic Builds**: Use `latexmk` or equivalent; builds must be reproducible across runs.

### Defensive Authoring
7. **Package Hygiene**: Load packages in dependency order; use `\RequirePackage` in classes/packages.
8. **Limited Scope**: Define commands with minimal scope; prefer local over global definitions.
9. **Guard Clauses**: Check for required packages and options using `\@ifpackageloaded` and `\IfFileExists`.
10. **Explicit Errors**: Use `\PackageError` and `\ClassError`; do not fail silently on missing dependencies.

### Document Clarity
11. **No Raw TeX in Documents**: Separate content from presentation; raw `\def` shall not appear in document bodies.
12. **Limited Primitive Use**: Avoid low-level TeX primitives (`\catcode`, `\the`, `\meaning`) in user-facing code.
13. **Small Macros**: Custom commands should be single-purpose; chain composition over monolithic definitions.
14. **Clear Environments**: Prefer environments over raw grouping for semantic blocks.

### Production Assurance
15. **Fault Isolation**: Non-critical packages (syntax highlighting, diagrams) must not crash compilation.
16. **Deterministic Output**: PDF output must be byte-reproducible with `SOURCE_DATE_EPOCH`; no embedded timestamps.
17. **Auditability**: Version control all sources; use `\listfiles` and embed version metadata in output.

## 2. Introduction

TeX, designed by Donald Knuth in 1978, represents one of computing's most rigorous typesetting systems. LaTeX, Leslie Lamport's macro layer atop TeX, provides document structuring but introduces complexity through macro expansion, catcode manipulation, and implicit state.

This standard codifies first-principles best practices for LaTeX development, drawing from:
- **Knuth's TeX: The Program** — The canonical source on TeX's algorithmic behaviour
- **The LaTeX Companion (3rd Edition)** — Comprehensive LaTeX usage patterns
- **expl3/L3 Interfaces** — The LaTeX3 programming layer for robust macro design
- **CTAN Package Guidelines** — Community standards for distributable code

The goal is to produce documents that compile predictably, fail gracefully, and yield reproducible output across engines (pdfTeX, XeTeX, LuaTeX) and platforms.

## 3. Scope

This standard applies to:
- **Document Classes** (`.cls` files) — Reusable structural definitions.
- **Package Files** (`.sty` files) — Reusable functionality extensions.
- **Master Documents** (`.tex` files) — Primary compilation units.
- **Build Systems** — `latexmk`, Makefiles, or CI/CD pipelines for compilation.

It specifically addresses:
- Academic theses, dissertations, and journal submissions.
- Technical documentation with mathematical notation.
- Multi-file projects with bibliography, indexing, and cross-references.

## 4. Conventions

- **Shall**: Indicates a mandatory requirement. Non-compliance must prevent publication.
- **Should**: Indicates a strong preference. Non-compliance requires documented justification.

## 5. Levels of Compliance

- **LOC-1 Language Compliance**: Ensures portable compilation across engines.
- **LOC-2 Predictable Compilation**: Focuses on termination, float placement, and build reproducibility.
- **LOC-3 Defensive Authoring**: Focuses on robust package loading and error handling.
- **LOC-4 Document Clarity**: Focuses on separation of concerns and maintainability.
- **LOC-5 Production Assurance**: Focuses on reproducibility, versioning, and publication readiness.

## 6. LOC-1: Language Compliance

### Rule 1 (Language Standard)
All code shall conform to LaTeX2e. Legacy LaTeX 2.09 constructs (`\documentstyle`, `\bf`, `\it`) are prohibited.

**Rationale**: LaTeX 2.09 was superseded in 1994. Modern engines deprecate its constructs, and they conflict with NFSS (New Font Selection Scheme) font handling.

**Implementation**:
```latex
% Correct: LaTeX2e
\documentclass{article}
\textbf{bold} \textit{italic}

% Prohibited: LaTeX 2.09
\documentstyle{article}  % DO NOT USE
{\bf bold} {\it italic}  % DO NOT USE
```

### Rule 2 (Compilation Warnings)
All documents shall compile without errors or warnings. Use `-halt-on-error` and resolve all overfull/underfull box warnings.

**Rationale**: Overfull boxes indicate content extending past margins; underfull boxes indicate poor line-breaking. Both degrade typographic quality and indicate algorithmic failures in TeX's paragraph builder.

**Implementation**:
```bash
# Compilation command with strict warnings
pdflatex -halt-on-error -file-line-error document.tex

# Check for badness warnings
grep -E "(Overfull|Underfull|Warning)" document.log && exit 1
```

## 7. LOC-2: Predictable Compilation

### Rule 3 (Loop Termination)
All loops (`\loop...\repeat`, `\@whilenum`, `\@for`) shall have explicit, statically verifiable termination conditions.

**Rationale**: TeX has no runtime timeout. An infinite loop freezes the compilation process indefinitely, requiring manual termination.

**Implementation**:
```latex
% Correct: Bounded loop
\newcount\mycount
\mycount=0
\loop
  \ifnum\mycount<10
    % Process item \the\mycount
    \advance\mycount by 1
\repeat

% Prohibited: Unbounded iteration
\loop\iftrue ... \repeat  % DO NOT USE
```

### Rule 4 (Expansion Control)
Recursive macro expansion shall use `expl3` control sequences (`\exp_args:N...`) rather than manual `\expandafter` chains.

**Rationale**: Manual expansion chains are error-prone and difficult to verify. The `expl3` layer provides structured, tested expansion primitives.

**Implementation**:
```latex
% Correct: expl3 expansion
\ExplSyntaxOn
\cs_new:Nn \my_process:n { ... }
\exp_args:No \my_process:n { \l_tmpa_tl }
\ExplSyntaxOff

% Discouraged: Manual expansion
\expandafter\expandafter\expandafter\mymacro...  % Avoid
```

### Rule 5 (Float Placement)
All floats (figures, tables) shall have explicit placement specifiers. The implicit `[tbp]` default shall not be relied upon.

**Rationale**: Implicit float placement leads to unpredictable figure positions across compilations. Explicit specifiers document author intent and stabilise output.

**Implementation**:
```latex
% Correct: Explicit placement
\begin{figure}[htbp]
  \centering
  \includegraphics{image}
  \caption{Description}
\end{figure}

% Prohibited: Implicit placement
\begin{figure}  % DO NOT USE without specifier
```

### Rule 6 (Reproducible Builds)
Compilation shall be automated via `latexmk` or equivalent. Multiple runs (for references, bibliographies) shall be handled automatically.

**Rationale**: LaTeX requires multiple passes to resolve cross-references and bibliographies. Manual multi-pass compilation is error-prone and non-reproducible.

**Implementation**:
```bash
# Correct: Automated build
latexmk -pdf -interaction=nonstopmode document.tex

# latexmkrc configuration
$pdf_mode = 1;
$bibtex_use = 2;
$pdflatex = 'pdflatex -halt-on-error -file-line-error %O %S';
```

## 8. LOC-3: Defensive Authoring

### Rule 7 (Package Loading Order)
Packages shall be loaded in dependency order. Conflicting packages shall be documented and resolved explicitly.

**Rationale**: Package load order affects macro redefinitions. `hyperref` notoriously conflicts with other packages and must typically be loaded last.

**Implementation**:
```latex
% Correct: Ordered loading with hyperref last
\usepackage{amsmath}
\usepackage{graphicx}
\usepackage{booktabs}
\usepackage[colorlinks]{hyperref}  % Load last

% Document known conflicts
% Note: cleveref must be loaded AFTER hyperref
\usepackage{cleveref}
```

### Rule 8 (Scope Minimisation)
Commands defined in packages shall use `\newcommand` or `\DeclareRobustCommand`. Global definitions (`\gdef`) shall be avoided.

**Rationale**: Global definitions pollute the namespace and persist beyond intended scope, causing subtle bugs across document sections.

**Implementation**:
```latex
% Correct: Local definition
\newcommand{\myterm}[1]{\textit{#1}}

% Prohibited: Global pollution
\gdef\myterm#1{\textit{#1}}  % DO NOT USE in user code
```

### Rule 9 (Dependency Checking)
Packages and classes shall verify dependencies using `\RequirePackage` and `\@ifpackageloaded`.

**Rationale**: Missing dependencies cause cryptic errors. Explicit checks provide actionable error messages.

**Implementation**:
```latex
% In .sty or .cls file
\NeedsTeXFormat{LaTeX2e}
\ProvidesPackage{mypackage}[2025/12/01 v1.0 My Package]

\RequirePackage{amsmath}

\@ifpackageloaded{hyperref}{%
  % hyperref-specific setup
}{%
  \PackageWarning{mypackage}{hyperref not loaded; links disabled}%
}
```

### Rule 10 (Explicit Errors)
Packages shall fail explicitly with `\PackageError` or `\ClassError`. Silent fallbacks that alter behaviour are prohibited.

**Rationale**: Silent fallbacks mask misconfigurations. Explicit errors force resolution before publication.

**Implementation**:
```latex
% Correct: Explicit error
\IfFileExists{required-data.dat}{%
  \input{required-data.dat}%
}{%
  \PackageError{mypackage}{required-data.dat not found}%
    {Ensure data file is in the search path}%
}

% Prohibited: Silent fallback
\IfFileExists{data.dat}{\input{data.dat}}{}  % DO NOT silently skip
```

## 9. LOC-4: Document Clarity

### Rule 11 (Separation of Concerns)
Document body files (`.tex`) shall contain only content and semantic markup. Low-level `\def`, `\let`, and catcode manipulation shall appear only in preambles or packages.

**Rationale**: Mixing presentation logic with content makes documents fragile and difficult to maintain. Semantic markup enables format-agnostic content.

**Implementation**:
```latex
% Correct: Content with semantic commands (in document body)
\begin{definition}
  A \term{group} is a set $G$ with an operation $\cdot$...
\end{definition}

% Prohibited: Raw TeX in body
\def\mydef#1{\textbf{#1}}  % DO NOT define in document body
```

### Rule 12 (Primitive Restriction)
TeX primitives (`\catcode`, `\the`, `\toks`, `\meaning`) shall not appear in user-facing document code.

**Rationale**: Primitives require deep TeX knowledge and break easily. They belong in package internals, not document authoring.

**Implementation**:
```latex
% Package internal (acceptable)
\makeatletter
\catcode`\@=11
...
\makeatother

% Document body (prohibited)
\catcode`\_=13  % DO NOT USE in documents
```

### Rule 13 (Macro Granularity)
Custom commands shall perform single, composable functions. Monolithic macros combining multiple operations are prohibited.

**Rationale**: Small, focused commands are testable, reusable, and maintainable. Monolithic macros become unmaintainable.

**Implementation**:
```latex
% Correct: Composable commands
\newcommand{\term}[1]{\textit{#1}\index{#1}}
\newcommand{\defterm}[1]{\textbf{\term{#1}}}

% Prohibited: Monolithic macro
\newcommand{\bigmacro}[5]{...100 lines...}  % DO NOT create
```

### Rule 14 (Semantic Environments)
Logical document blocks shall use environments. Raw `\begingroup...\endgroup` for content is prohibited.

**Rationale**: Environments provide hooks for formatting, numbering, and cross-referencing. They enable consistent styling via class/package updates.

**Implementation**:
```latex
% Correct: Semantic environment
\begin{theorem}[Fundamental Theorem]
  Content here...
\end{theorem}

% Prohibited: Raw grouping for theorems
\begingroup\bfseries Theorem. \endgroup Content...  % DO NOT USE
```

## 10. LOC-5: Production Assurance

### Rule 15 (Fault Isolation)
Non-critical packages (syntax highlighting, diagrams) shall be wrapped in conditional loading to prevent compilation failure if unavailable.

**Rationale**: A missing optional package should not prevent document compilation. Core content must compile independently of enhancement packages.

**Implementation**:
```latex
% Conditional loading of optional packages
\IfFileExists{minted.sty}{%
  \usepackage{minted}%
  \newminted{python}{}%
}{%
  % Fallback: basic verbatim
  \newenvironment{pythoncode}{\verbatim}{\endverbatim}%
  \PackageWarning{document}{minted unavailable; using fallback}%
}
```

### Rule 16 (Reproducible Output)
PDF output shall be byte-reproducible. Set `SOURCE_DATE_EPOCH` and disable embedded timestamps and unique IDs.

**Rationale**: Reproducible builds enable verification that outputs match sources. Embedded timestamps break diff-based review and archival.

**Implementation**:
```bash
# Environment for reproducible builds
export SOURCE_DATE_EPOCH=$(date -d '2025-01-01' +%s)
pdflatex -halt-on-error document.tex

# Or via pdflatex primitives
\pdfinfoomitdate=1
\pdftrailerid{}
```

For LuaTeX:
```latex
\directlua{
  pdf.settrailerid{
    string.rep("0", 32),
    string.rep("0", 32)
  }
}
```

### Rule 17 (Version Control & Auditability)
All source files shall be version-controlled. Documents shall embed version metadata and list loaded files.

**Rationale**: Auditability requires tracing outputs to exact source versions. `\listfiles` provides package version logging for debugging.

**Implementation**:
```latex
% In preamble
\listfiles  % Log all loaded files to .log

% Embed version (from git)
\newcommand{\docversion}{%
  \input|"git describe --tags --always 2>/dev/null || echo 'unknown'"%
}

% Or manual versioning
\newcommand{\docversion}{v1.2.3}
\date{December 2025 (\docversion)}
```

## 11. References

1. **Knuth, D.E.** (1986). *The TeXbook*. Addison-Wesley.
2. **Knuth, D.E.** (1986). *TeX: The Program*. Addison-Wesley.
3. **Lamport, L.** (1994). *LaTeX: A Document Preparation System* (2nd ed.). Addison-Wesley.
4. **Mittelbach, F., et al.** (2023). *The LaTeX Companion* (3rd ed.). Addison-Wesley.
5. **The LaTeX3 Project.** *The expl3 Package and LaTeX3 Programming*. CTAN.
6. **CTAN Guidelines.** Package Submission and Quality Standards. https://ctan.org/
7. **Reproducible Builds Project.** Achieving Reproducible PDF Output. https://reproducible-builds.org/
