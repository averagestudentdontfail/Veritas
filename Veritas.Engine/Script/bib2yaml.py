#!/usr/bin/env python3
"""Convert BibTeX files to YAML references and embed in markdown frontmatter."""

import re
import sys
from pathlib import Path

def parse_bibtex(bib_content):
    """Parse BibTeX content into list of reference dicts."""
    references = []
    
    # Match @type{key, ... }
    pattern = r'@(\w+)\{([^,]+),([^@]*)\}'
    matches = re.findall(pattern, bib_content, re.DOTALL)
    
    for entry_type, key, fields_str in matches:
        ref = {'id': key.strip(), 'type': map_type(entry_type.lower())}
        
        # Parse fields
        field_pattern = r'(\w+)\s*=\s*\{([^}]*)\}'
        fields = re.findall(field_pattern, fields_str)
        
        for field_name, field_value in fields:
            field_name = field_name.lower().strip()
            field_value = field_value.strip()
            
            if field_name == 'author':
                ref['author'] = parse_authors(field_value)
            elif field_name == 'title':
                ref['title'] = field_value
            elif field_name == 'journal':
                ref['container-title'] = field_value
            elif field_name == 'booktitle':
                ref['container-title'] = field_value
            elif field_name == 'year':
                if field_value.strip():
                    ref['issued'] = {'date-parts': [[int(field_value)]]}
            elif field_name == 'volume':
                ref['volume'] = field_value
            elif field_name == 'number':
                ref['issue'] = field_value
            elif field_name == 'pages':
                ref['page'] = field_value.replace('--', '-')
            elif field_name == 'publisher':
                ref['publisher'] = field_value
            elif field_name == 'doi':
                ref['DOI'] = field_value
            elif field_name == 'edition':
                ref['edition'] = field_value
            elif field_name == 'address':
                ref['publisher-place'] = field_value
        
        references.append(ref)
    
    return references

def map_type(bib_type):
    """Map BibTeX type to CSL type."""
    type_map = {
        'article': 'article-journal',
        'book': 'book',
        'inbook': 'chapter',
        'incollection': 'chapter',
        'inproceedings': 'paper-conference',
        'manual': 'book',
        'misc': 'document',
        'phdthesis': 'thesis',
        'mastersthesis': 'thesis',
        'techreport': 'report',
        'unpublished': 'manuscript'
    }
    return type_map.get(bib_type, 'document')

def parse_authors(author_str):
    """Parse author string into list of author dicts."""
    authors = []
    # Split by 'and'
    author_parts = re.split(r'\s+and\s+', author_str)
    
    for author in author_parts:
        author = author.strip()
        if not author:
            continue
        
        # Check for "Last, First" format
        if ',' in author:
            parts = author.split(',', 1)
            family = parts[0].strip()
            given = parts[1].strip() if len(parts) > 1 else ''
        else:
            # "First Last" format
            parts = author.rsplit(' ', 1)
            if len(parts) == 2:
                given = parts[0].strip()
                family = parts[1].strip()
            else:
                family = author
                given = ''
        
        authors.append({'family': family, 'given': given})
    
    return authors

def ref_to_yaml(ref, indent=2):
    """Convert reference dict to YAML string."""
    lines = []
    ind = ' ' * indent
    
    lines.append(f"{ind}- id: {ref['id']}")
    
    if 'author' in ref:
        lines.append(f"{ind}  author:")
        for author in ref['author']:
            lines.append(f"{ind}    - family: \"{author['family']}\"")
            if author.get('given'):
                lines.append(f"{ind}      given: \"{author['given']}\"")
    
    if 'title' in ref:
        lines.append(f"{ind}  title: \"{ref['title']}\"")
    
    if 'container-title' in ref:
        lines.append(f"{ind}  container-title: \"{ref['container-title']}\"")
    
    if 'issued' in ref:
        year = ref['issued']['date-parts'][0][0]
        lines.append(f"{ind}  issued:")
        lines.append(f"{ind}    date-parts:")
        lines.append(f"{ind}      - [{year}]")
    
    if 'volume' in ref:
        lines.append(f"{ind}  volume: {ref['volume']}")
    
    if 'issue' in ref:
        lines.append(f"{ind}  issue: {ref['issue']}")
    
    if 'page' in ref:
        lines.append(f"{ind}  page: \"{ref['page']}\"")
    
    if 'publisher' in ref:
        lines.append(f"{ind}  publisher: \"{ref['publisher']}\"")
    
    if 'publisher-place' in ref:
        lines.append(f"{ind}  publisher-place: \"{ref['publisher-place']}\"")
    
    if 'DOI' in ref:
        lines.append(f"{ind}  DOI: \"{ref['DOI']}\"")
    
    if 'edition' in ref:
        lines.append(f"{ind}  edition: \"{ref['edition']}\"")
    
    lines.append(f"{ind}  type: {ref['type']}")
    
    return '\n'.join(lines)

def convert_bib_to_yaml(bib_path):
    """Convert a .bib file to YAML references string."""
    with open(bib_path, 'r') as f:
        content = f.read()
    
    refs = parse_bibtex(content)
    yaml_lines = ['references:']
    
    for ref in refs:
        yaml_lines.append(ref_to_yaml(ref))
    
    return '\n'.join(yaml_lines)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: bib2yaml.py <bibfile.bib>")
        sys.exit(1)
    
    bib_path = sys.argv[1]
    print(convert_bib_to_yaml(bib_path))
