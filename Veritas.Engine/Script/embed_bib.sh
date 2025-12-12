#!/bin/bash
# Embed YAML bibliography from .bib file into markdown frontmatter
# Usage: embed_bib.sh <markdown.md> <bibliography.bib>

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MD_FILE="$1"
BIB_FILE="$2"

if [[ ! -f "$MD_FILE" ]] || [[ ! -f "$BIB_FILE" ]]; then
    echo "Usage: embed_bib.sh <markdown.md> <bibliography.bib>"
    exit 1
fi

# Generate YAML references
YAML_REFS=$(python3 "$SCRIPT_DIR/bib2yaml.py" "$BIB_FILE")

# Create temp file
TEMP_FILE=$(mktemp)

# Read markdown and insert references before closing ---
awk -v refs="$YAML_REFS" '
    BEGIN { in_frontmatter = 0; frontmatter_count = 0 }
    /^---$/ {
        frontmatter_count++
        if (frontmatter_count == 2) {
            print refs
        }
        print
        next
    }
    { print }
' "$MD_FILE" > "$TEMP_FILE"

mv "$TEMP_FILE" "$MD_FILE"
echo "Embedded bibliography into: $MD_FILE"
