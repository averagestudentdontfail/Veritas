% Veritas LaTeX Document Class
% Version: 1.0.0 - 2025-12-12
% Based on: IPLeiria Thesis by José Areia (jose.apareia@gmail.com)
%
% FIRST PRINCIPLES BASIS:
% This class implements a general-purpose academic document template derived from:
% - Bringhurst, R. (2012). The Elements of Typographic Style. 4th ed.
% - Tschichold, J. (1991). The Form of the Book. Lund Humphries.
% - The LaTeX Companion, 3rd Edition (2023).
%
% COMPLIANCE: Standard.md LOC-1 through LOC-5
% - LOC-1: LaTeX2e conformant, no deprecated syntax
% - LOC-2: Explicit float placement, deterministic builds
% - LOC-3: Package dependency guards, explicit errors
% - LOC-4: Separation of content and presentation
% - LOC-5: Reproducible output, version metadata

%%% Class Information %%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{Veritas}[2025/12/12 v1.0.0 Veritas Academic Document Class]

\RequirePackage{expl3} % Required for writing LaTeX3 code in this class.

%%% Handle Class Options %%%
\ExplSyntaxOn

\cs_new:Npn \Veritas_check_color:n #1 {
  \tl_set:Nn \l_tmpa_tl { #1 }
  \color_set:nn { \l_tmpa_tl } { #1 }
}

\keys_define:nn { Veritas } {
    % Cover style: classic or black-and-white
    coverstyle .choices:nn =
        { classic, bw, fancy }
        { \tl_gset:Nn \g_Veritas_mycover_tl { #1 } },
    coverstyle / unknown .code:n = 
        { \ClassWarningNoLine{Veritas}{Specified~'coverstyle'~not~available.~Defaulting~to~'classic'} },
    coverstyle .default:n = { classic },
    coverstyle .initial:n = { classic },

    % Document language
    language .choices:nn = 
        { english, portuguese } 
        { \tl_gset:Nn \g_Veritas_mylanguage_tl { #1 } },
    language / unknown .code:n = 
        { \ClassWarningNoLine{Veritas}{Specified~'language'~not~available.~Defaulting~to~'english'} },
    language .default:n = { english },
    language .initial:n = { english },

    % Chapter heading style
    chapterstyle .choices:nn = 
        { classic, fancy, modern } 
        { \tl_gset:Nn \g_Veritas_style_tl { #1 } },
    chapterstyle / unknown .code:n = 
        { \ClassWarningNoLine{Veritas}{Specified~'chapterstyle'~not~available.~Defaulting~to~'classic'} },
    chapterstyle .default:n = { classic },
    chapterstyle .initial:n = { classic },

    % Document stage: working (with version footer) or final
    docstage .choices:nn = 
        { working, final } 
        { \tl_gset:Nn \g_Veritas_docstage_tl { #1 } },
    docstage / unknown .code:n = 
        { \ClassWarningNoLine{Veritas}{Specified~'docstage'~not~available.~Defaulting~to~'working'} },
    docstage .default:n = { working },
    docstage .initial:n = { working },

    % Output media: paper (with blank pages) or screen
    media .choices:nn = 
        { paper, screen } 
        { \tl_gset:Nn \g_Veritas_media_tl { #1 } },
    media / unknown .code:n = 
        { \ClassWarningNoLine{Veritas}{Specified~'media'~not~available.~Defaulting~to~'paper'} },
    media .default:n = { paper },
    media .initial:n = { paper },

    % Hyperlink color
    linkcolor .code:n = {
        \tl_gset:Nn \g_Veritas_linkcolor_tl { #1 }
        \Veritas_check_color:n { #1 }
        \tl_if_eq:NNTF \l_tmpa_tl \q_no_value {
            \tl_gset:Nn \g_Veritas_linkcolor_tl { black }
            \ClassWarningNoLine{Veritas}{Specified~'linkcolor'~not~available.~Defaulting~to~'black'}
        }
    },
    linkcolor .default:n = { black },
    linkcolor .initial:n = { black },

    % Document type
    doctype .choices:nn = 
        { thesis, report, article } 
        { \tl_gset:Nn \g_Veritas_doctype_tl { #1 } },
    doctype / unknown .code:n = 
        { \ClassWarningNoLine{Veritas}{Specified~'doctype'~not~available.~Defaulting~to~'thesis'} },
    doctype .default:n = { thesis },
    doctype .initial:n = { thesis },

    % Book printing mode (for physical binding)
    bookprint .choices:nn = 
        { true, false } 
        { \tl_gset:Nn \g_Veritas_bookprint_tl { #1 } },
    bookprint / unknown .code:n = 
        { \ClassWarningNoLine{Veritas}{Specified~'bookprint'~not~available.~Defaulting~to~'false'} },
    bookprint .default:n = { false },
    bookprint .initial:n = { false },

    % AI acknowledgement section
    aiack .choices:nn = 
        { true, false } 
        { \tl_gset:Nn \g_Veritas_aiack_tl { #1 } },
    aiack / unknown .code:n = 
        { \ClassWarningNoLine{Veritas}{Specified~'aiack'~not~available.~Defaulting~to~'true'} },
    aiack .default:n = { true },
    aiack .initial:n = { true },
    
    unknown .code:n = 
        { \ClassWarningNoLine{Veritas}{An~unknown~option~was~ignored.~Please~check~the~documentation~to~see~the~available~options} }
}

% Export option accessors
\newcommand{\LanguageOption}{\g_Veritas_mylanguage_tl}
\newcommand{\CoverOption}{\g_Veritas_mycover_tl}
\newcommand{\ChapterOption}{\g_Veritas_style_tl}
\newcommand{\DocStageOption}{\g_Veritas_docstage_tl}
\newcommand{\MediaOption}{\g_Veritas_media_tl}
\newcommand{\ColorOption}{\g_Veritas_linkcolor_tl}
\newcommand{\DocTypeOption}{\g_Veritas_doctype_tl}
\newcommand{\BookPrintOption}{\g_Veritas_bookprint_tl}
\newcommand{\AiAckOption}{\g_Veritas_aiack_tl}

\ProcessKeyOptions[Veritas]
\ExplSyntaxOff

%%% Load Master Class %%%
\LoadClass[a4paper,11pt,oneside]{report}

%%% Load Babel Package (Language) %%%
\expandafter\RequirePackage\expandafter[\LanguageOption]{babel}

%%% Required Packages %%%
% LOC-3 Rule 7: Packages loaded in dependency order

\RequirePackage{ifthen} % Provides conditional statements.
\RequirePackage{etoolbox} % Advanced programming tools for LaTeX.
\RequirePackage{graphicx} % For including and manipulating images.
\RequirePackage{subcaption} % Subfigures and side-by-side captions.
\RequirePackage{tabularx} % Flexible-width tables.
\RequirePackage{xltabular} % Same as tabularx but to be used in long tables.
\RequirePackage{afterpage} % Execute commands after the current page.
\RequirePackage{booktabs} % Professional table styling.
\RequirePackage{multirow} % Support for multirow cells in tables.
\RequirePackage{longtable} % Tables spanning multiple pages.
\RequirePackage{array} % Enhanced table column specifications.
\RequirePackage{colortbl} % Add color to table rows and columns.
\RequirePackage{makecell} % Enhanced cell formatting in tables.
\RequirePackage{siunitx} % Consistent formatting of numbers and units.
\RequirePackage{caption} % Customisation of captions.
\RequirePackage{enumitem} % Customisation of lists.
\RequirePackage{amsmath} % Advanced mathematical expressions.
\RequirePackage{amssymb} % Extended mathematical symbols.
\RequirePackage[dvipsnames]{xcolor} % Extended color support.
\RequirePackage{tcolorbox} % Creating colored and highlighted boxes.
\RequirePackage{varwidth} % Allows variable-width boxes.
\RequirePackage{titlesec} % Customisation of section and chapter titles.
\RequirePackage{titling} % Control over title and titlepage formatting.
\RequirePackage[toc,page]{appendix} % Formatting for appendices.
\RequirePackage[bookmarks,pdfusetitle]{hyperref} % Hyperlinks and PDF metadata.
\RequirePackage[symbols,acronym]{glossaries} % Create glossaries and acronyms.
\RequirePackage[calc,datesep={/}]{datetime2} % Enhanced date and time formatting.
\RequirePackage{xparse} % Advanced argument parsing for custom macros.
\RequirePackage{typearea} % Page layout adjustments (KOMA-Script).
\RequirePackage{eso-pic} % Adding elements to the page background.
\RequirePackage{setspace} % Adjust line spacing.

% LOC-5 Rule 15: Conditional loading for minted (non-critical package)
\IfFileExists{minted.sty}{%
    \RequirePackage[newfloat,outputdir=.aux]{minted}%
}{%
    \ClassWarning{Veritas}{minted package not found; code highlighting disabled}%
}

\RequirePackage{silence} % Suppress specific package warnings.
\RequirePackage{fontawesome5} % Font awesome icons.
\RequirePackage{calc} % Infix notation arithmetic.
\RequirePackage{soul} % A better underline.
\RequirePackage{mfirstuc} % Capitalise words in a sentence.
\RequirePackage{adjustbox}  % For slight rotation
\RequirePackage{pagecolor}  % For paper background
\RequirePackage{tikz} % Create high-quality graphics programmatically.
\usetikzlibrary{positioning}
\RequirePackage{psvectorian} % To include in-text ornamentations. 
\RequirePackage{blindtext} % Generate placeholder text.
\RequirePackage{float}      % For [H] placement option
\RequirePackage{pdflscape} % Landscape pages with proper PDF orientation

\tcbuselibrary{most} % Load most libraries from the tcolorbox package.
\WarningsOff[blindtext] % Suppress warnings from the blindtext package.

%%% Configure siunitx for tables %%%
\sisetup{
    detect-mode,
    tight-spacing = true,
    group-digits = false,
    input-signs = ,
    input-symbols = (),
    input-open-uncertainty = ,
    input-close-uncertainty = ,
    table-align-text-pre = false,
    table-align-text-post = false,
}

%%% Import Configurations - Maintain the Specified Order! %%%
% LOC-3 Rule 7: Load order is critical; hyperref settings in 03-References
\usepackage{Configurations/00-Fonts}
\usepackage{Configurations/01-Colors}
\usepackage{Configurations/02-Margins}
\usepackage{Configurations/03-References}
\usepackage{Configurations/04-Headers}
\usepackage{Configurations/05-Contents}
\usepackage{Configurations/06-Glossary}
\usepackage{Configurations/07-Chapters}
\usepackage{Configurations/08-Tables}
\usepackage{Configurations/09-Code}
\usepackage{Configurations/10-Macros}
\usepackage{Configurations/11-Metadata}
\usepackage{Configurations/12-Floats}
