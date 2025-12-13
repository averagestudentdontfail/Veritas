# Veritas LaTeX configuration for latexmk
# Forces XeLaTeX as the compiler engine (required for fontspec)

# Use XeLaTeX for PDF output
$pdf_mode = 5;  # 5 = use xelatex

# Enable shell escape (required for minted)
$xelatex = 'xelatex -shell-escape -synctex=1 -interaction=nonstopmode -file-line-error %O %S';

# Output directory for auxiliary files
$aux_dir = '.aux';
$out_dir = '.';
