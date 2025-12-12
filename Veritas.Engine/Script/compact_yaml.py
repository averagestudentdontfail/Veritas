#!/usr/bin/env python3
"""Reformat YAML references in markdown files to be more compact."""

import re
import sys
import yaml
from pathlib import Path

def compact_author(author_list):
    """Convert author list to compact string format."""
    authors = []
    for a in author_list:
        given = a.get('given', '').replace('"', '')
        family = a.get('family', '').replace('"', '')
        if given:
            authors.append(f"{family}, {given}")
        else:
            authors.append(family)
    return " and ".join(authors)

def compact_reference(ref):
    """Convert a reference dict to compact YAML lines."""
    lines = []
    ref_id = ref.get('id', 'unknown')
    
    # Build compact representation
    compact = {'id': ref_id}
    
    if 'author' in ref:
        compact['author'] = compact_author(ref['author'])
    if 'title' in ref:
        compact['title'] = ref['title'].replace('"', '')
    if 'container-title' in ref:
        compact['journal'] = ref['container-title'].replace('"', '')
    if 'issued' in ref and 'date-parts' in ref['issued']:
        compact['year'] = ref['issued']['date-parts'][0][0]
    if 'volume' in ref:
        compact['volume'] = ref['volume']
    if 'issue' in ref:
        compact['issue'] = ref['issue']
    if 'page' in ref:
        compact['pages'] = str(ref['page']).replace('"', '')
    if 'DOI' in ref:
        compact['doi'] = ref['DOI'].replace('"', '')
    if 'publisher' in ref:
        compact['publisher'] = ref['publisher'].replace('"', '')
    if 'type' in ref:
        compact['type'] = ref['type']
    
    return compact

def reformat_markdown(md_path):
    """Reformat the YAML frontmatter references to be more compact."""
    with open(md_path, 'r') as f:
        content = f.read()
    
    # Split into frontmatter and body
    parts = content.split('---', 2)
    if len(parts) < 3:
        print(f"No valid frontmatter in {md_path}")
        return
    
    frontmatter_str = parts[1]
    body = parts[2]
    
    # Parse YAML
    try:
        frontmatter = yaml.safe_load(frontmatter_str)
    except yaml.YAMLError as e:
        print(f"YAML error in {md_path}: {e}")
        return
    
    if not frontmatter or 'references' not in frontmatter:
        print(f"No references in {md_path}")
        return
    
    # Extract and compact references
    refs = frontmatter.pop('references')
    compact_refs = [compact_reference(ref) for ref in refs]
    
    # Rebuild frontmatter with compact references at end
    new_fm_lines = ['---']
    for key, value in frontmatter.items():
        if isinstance(value, str):
            new_fm_lines.append(f'{key}: "{value}"')
        else:
            new_fm_lines.append(f'{key}: {value}')
    
    # Add references in compact format
    new_fm_lines.append('references:')
    for ref in compact_refs:
        ref_id = ref.pop('id')
        new_fm_lines.append(f'  - id: {ref_id}')
        for key, value in ref.items():
            if isinstance(value, str):
                # Escape quotes in values
                value = value.replace('"', '\\"')
                new_fm_lines.append(f'    {key}: "{value}"')
            else:
                new_fm_lines.append(f'    {key}: {value}')
    
    new_fm_lines.append('---')
    
    # Combine and write
    new_content = '\n'.join(new_fm_lines) + body
    
    with open(md_path, 'w') as f:
        f.write(new_content)
    
    print(f"Reformatted: {md_path}")

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: compact_yaml.py <markdown.md>")
        sys.exit(1)
    
    for path in sys.argv[1:]:
        reformat_markdown(path)
