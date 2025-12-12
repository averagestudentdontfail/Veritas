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
    """Convert a reference dict to compact YAML lines - keeping CSL format."""
    ref_id = ref.get('id', 'unknown')
    
    # Keep CSL-compatible format but more compact
    compact = {'id': ref_id}
    
    # Authors need to stay as structured data for citeproc
    if 'author' in ref:
        # Keep as list of dicts but compact
        authors = []
        for a in ref['author']:
            given = a.get('given', '').replace('"', '')
            family = a.get('family', '').replace('"', '')
            authors.append({'family': family, 'given': given})
        compact['author'] = authors
    
    if 'title' in ref:
        compact['title'] = ref['title'].replace('"', '')
    if 'container-title' in ref:
        compact['container-title'] = ref['container-title'].replace('"', '')
    
    # Keep issued in proper CSL format
    if 'issued' in ref and 'date-parts' in ref['issued']:
        compact['issued'] = ref['issued']
    
    if 'volume' in ref:
        compact['volume'] = str(ref['volume'])
    if 'issue' in ref:
        compact['issue'] = str(ref['issue'])
    if 'page' in ref:
        compact['page'] = str(ref['page']).replace('"', '')
    if 'DOI' in ref:
        compact['DOI'] = ref['DOI'].replace('"', '')
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
    refs = frontmatter['references']
    compact_refs = [compact_reference(ref) for ref in refs]
    frontmatter['references'] = compact_refs
    
    # Serialize with yaml.dump for proper formatting
    new_frontmatter = yaml.dump(frontmatter, 
                                 default_flow_style=False, 
                                 allow_unicode=True,
                                 sort_keys=False,
                                 width=120)
    
    # Combine and write
    new_content = '---\n' + new_frontmatter + '---' + body
    
    with open(md_path, 'w') as f:
        f.write(new_content)
    
    print(f"Reformatted: {md_path}")

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: compact_yaml.py <markdown.md>")
        sys.exit(1)
    
    for path in sys.argv[1:]:
        reformat_markdown(path)
