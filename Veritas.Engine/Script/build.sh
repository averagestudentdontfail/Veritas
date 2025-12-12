#!/bin/bash
# Veritas.Engine - Markdown to PDF Pipeline
# Converts all .md files in Veritas.Input to PDF in Veritas.Output
#
# Usage: ./build.sh [filename.md]
#   If filename provided, converts only that file
#   Otherwise, converts all .md files in Veritas.Input
#
# Dependencies:
#   - pandoc >= 2.0
#   - XeLaTeX
#   - Veritas.Class template

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENGINE_DIR="$(dirname "$SCRIPT_DIR")"
VERITAS_ROOT="$(dirname "$ENGINE_DIR")"

INPUT_DIR="$VERITAS_ROOT/Veritas.Input"
OUTPUT_DIR="$VERITAS_ROOT/Veritas.Output"
CLASS_DIR="$VERITAS_ROOT/Veritas.Class"
PANDOC_TEMPLATE="$ENGINE_DIR/Converter/veritas.latex"

# Ensure directories exist
mkdir -p "$OUTPUT_DIR"

# Check for pandoc
if ! command -v pandoc &> /dev/null; then
    echo "Error: pandoc is required but not installed."
    echo "Install with: sudo apt install pandoc"
    exit 1
fi

convert_file() {
    local input_file="$1"
    local basename=$(basename "$input_file" .md)
    local tex_file="$CLASS_DIR/Main.tex"
    local pdf_output="$OUTPUT_DIR/${basename}.pdf"
    
    echo "Converting: $input_file"
    echo "  → LaTeX: $tex_file"
    
    # Convert MD to LaTeX using Pandoc with citeproc for inline references
    pandoc "$input_file" \
        --from=markdown+yaml_metadata_block+tex_math_dollars+raw_tex \
        --to=latex \
        --template="$PANDOC_TEMPLATE" \
        --citeproc \
        --standalone \
        --output="$tex_file"
    
    # Copy bibliography files if they exist
    if [[ -d "$INPUT_DIR/Bibliography" ]]; then
        cp "$INPUT_DIR/Bibliography/"*.bib "$CLASS_DIR/Bibliography/" 2>/dev/null || true
    fi
    
    # Build PDF in Veritas.Class
    echo "  → Building PDF..."
    (cd "$CLASS_DIR" && make clean > /dev/null 2>&1 && make > /dev/null 2>&1)
    
    # Copy PDF to output
    if [[ -f "$CLASS_DIR/Main.pdf" ]]; then
        cp "$CLASS_DIR/Main.pdf" "$pdf_output"
        echo "  → Output: $pdf_output"
    else
        echo "  → Error: PDF generation failed"
        return 1
    fi
}

# Main logic
if [[ $# -ge 1 ]]; then
    # Convert specific file
    if [[ -f "$1" ]]; then
        convert_file "$1"
    elif [[ -f "$INPUT_DIR/$1" ]]; then
        convert_file "$INPUT_DIR/$1"
    else
        echo "Error: File not found: $1"
        exit 1
    fi
else
    # Convert all .md files in Input
    echo "Building all documents in Veritas.Input..."
    echo ""
    
    for md_file in "$INPUT_DIR"/*.md; do
        if [[ -f "$md_file" ]]; then
            convert_file "$md_file"
            echo ""
        fi
    done
    
    echo "All documents built. Output in: $OUTPUT_DIR"
fi
