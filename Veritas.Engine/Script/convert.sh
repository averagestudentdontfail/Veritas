#!/bin/bash
# Veritas.Engine - Markdown to LaTeX Converter
# Uses Pandoc with Veritas template for conversion
#
# Usage: ./convert.sh input.md [output.tex]
#
# Dependencies:
#   - pandoc >= 2.0
#   - Veritas template in ../Veritas.Class/

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENGINE_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATE_DIR="$ENGINE_DIR/../Veritas.Class"

# Pandoc template for Veritas
PANDOC_TEMPLATE="$ENGINE_DIR/Converter/veritas.latex"

# Input validation
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 input.md [output.tex]"
    echo "  input.md   - Markdown file to convert"
    echo "  output.tex - Output LaTeX file (default: input.tex)"
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="${2:-${INPUT_FILE%.md}.tex}"

if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: Input file not found: $INPUT_FILE"
    exit 1
fi

# Check for pandoc
if ! command -v pandoc &> /dev/null; then
    echo "Error: pandoc is required but not installed."
    echo "Install with: sudo apt install pandoc"
    exit 1
fi

# Convert with Pandoc
echo "Converting $INPUT_FILE → $OUTPUT_FILE"
pandoc "$INPUT_FILE" \
    --from=markdown+yaml_metadata_block+tex_math_dollars+raw_tex \
    --to=latex \
    --template="$PANDOC_TEMPLATE" \
    --standalone \
    --output="$OUTPUT_FILE"

echo "Conversion complete: $OUTPUT_FILE"
