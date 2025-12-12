% Veritas LaTeX Document Class
% Version: 2.0.0 - 2025-12-12
% Based on: IPLeiria Thesis by José Areia (jose.apareia@gmail.com)
%
% FIRST PRINCIPLES BASIS:
% This class implements a general-purpose academic document template derived from:
% - Bringhurst, R. (2012). The Elements of Typographic Style. 4th ed.
% - Tschichold, J. (1991). The Form of the Book. Lund Humphries.
% - Williamson, H. (1983). Methods of Book Design. Yale University Press.
% - The LaTeX Companion, 3rd Edition (2023).
%
% COMPLIANCE: Standard.md LOC-1 through LOC-5

%%% Class Information %%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{Veritas}[2025/12/12 v2.0.0 Veritas Academic Document Class]

\RequirePackage{expl3}

%%% Handle Class Options %%%
\ExplSyntaxOn

\cs_new:Npn \Veritas_check_color:n #1 {
  \tl_set:Nn \l_tmpa_tl { #1 }
  \color_set:nn { \l_tmpa_tl } { #1 }
}

\keys_define:nn { Veritas } {
    % Cover page: include separate cover or not
    cover .choices:nn =
        { true, false }
        { \tl_gset:Nn \g_Veritas_cover_tl { #1 } },
    cover / unknown .code:n = 
        { \ClassWarningNoLine{Veritas}{Specified~'cover'~not~available.~Defaulting~to~'false'} },
    cover .default:n = { false },
    cover .initial:n = { false },

    % Cover style (only relevant if cover=true)
    coverstyle .choices:nn =
        { classic, bw }
        { \tl_gset:Nn \g_Veritas_coverstyle_tl { #1 } },
    coverstyle / unknown .code:n = 
        { \ClassWarningNoLine{Veritas}{Specified~'coverstyle'~not~available.~Defaulting~to~'bw'} },
    coverstyle .default:n = { bw },
    coverstyle .initial:n = { bw },

    % Document language: English or German
    language .choices:nn = 
        { english, german } 
        { \tl_gset:Nn \g_Veritas_mylanguage_tl { #1 } },
    language / unknown .code:n = 
        { \ClassWarningNoLine{Veritas}{Specified~'language'~not~available.~Defaulting~to~'english'} },
    language .default:n = { english },
    language .initial:n = { english },

    % Chapter heading style
    chapterstyle .choices:nn = 
        { classic, fancy, modern, minimal } 
        { \tl_gset:Nn \g_Veritas_style_tl { #1 } },
    chapterstyle / unknown .code:n = 
        { \ClassWarningNoLine{Veritas}{Specified~'chapterstyle'~not~available.~Defaulting~to~'minimal'} },
    chapterstyle .default:n = { minimal },
    chapterstyle .initial:n = { minimal },

    % Document stage: working (with version footer) or final
    docstage .choices:nn = 
        { working, final } 
        { \tl_gset:Nn \g_Veritas_docstage_tl { #1 } },
    docstage / unknown .code:n = 
        { \ClassWarningNoLine{Veritas}{Specified~'docstage'~not~available.~Defaulting~to~'final'} },
    docstage .default:n = { final },
    docstage .initial:n = { final },

    % Output media: screen (default) or paper (with blank pages)
    media .choices:nn = 
        { paper, screen } 
        { \tl_gset:Nn \g_Veritas_media_tl { #1 } },
    media / unknown .code:n = 
        { \ClassWarningNoLine{Veritas}{Specified~'media'~not~available.~Defaulting~to~'screen'} },
    media .default:n = { screen },
    media .initial:n = { screen },

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
        { \ClassWarningNoLine{Veritas}{Specified~'doctype'~not~available.~Defaulting~to~'article'} },
    doctype .default:n = { article },
    doctype .initial:n = { article },

    % Book printing mode (for physical binding)
    % Williamson (1983): gutter 25mm, outer 1.5× inner
    bookprint .choices:nn = 
        { true, false } 
        { \tl_gset:Nn \g_Veritas_bookprint_tl { #1 } },
    bookprint / unknown .code:n = 
        { \ClassWarningNoLine{Veritas}{Specified~'bookprint'~not~available.~Defaulting~to~'false'} },
    bookprint .default:n = { false },
    bookprint .initial:n = { false },
    
    unknown .code:n = 
        { \ClassWarningNoLine{Veritas}{An~unknown~option~was~ignored.~Please~check~the~documentation} }
}

% Export option accessors
\newcommand{\LanguageOption}{\g_Veritas_mylanguage_tl}
\newcommand{\CoverOption}{\g_Veritas_cover_tl}
\newcommand{\CoverStyleOption}{\g_Veritas_coverstyle_tl}
\newcommand{\ChapterOption}{\g_Veritas_style_tl}
\newcommand{\DocStageOption}{\g_Veritas_docstage_tl}
\newcommand{\MediaOption}{\g_Veritas_media_tl}
\newcommand{\ColorOption}{\g_Veritas_linkcolor_tl}
\newcommand{\DocTypeOption}{\g_Veritas_doctype_tl}
\newcommand{\BookPrintOption}{\g_Veritas_bookprint_tl}

\ProcessKeyOptions[Veritas]
\ExplSyntaxOff

%%% Load Master Class %%%
\LoadClass[a4paper,11pt,oneside]{report}

%%% Load Babel Package (Language) %%%
\expandafter\RequirePackage\expandafter[\LanguageOption]{babel}

%%% Required Packages %%%
\RequirePackage{ifthen}
\RequirePackage{etoolbox}
\RequirePackage{graphicx}
\RequirePackage{subcaption}
\RequirePackage{tabularx}
\RequirePackage{xltabular}
\RequirePackage{afterpage}
\RequirePackage{booktabs}
\RequirePackage{multirow}
\RequirePackage{longtable}
\RequirePackage{array}
\RequirePackage{colortbl}
\RequirePackage{makecell}
\RequirePackage{siunitx}
\RequirePackage{caption}
\RequirePackage{enumitem}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{tcolorbox}
\RequirePackage{varwidth}
\RequirePackage{titlesec}
\RequirePackage{titling}
\RequirePackage[toc,page]{appendix}
\RequirePackage[bookmarks,pdfusetitle]{hyperref}
\RequirePackage[symbols,acronym]{glossaries}
\RequirePackage[calc,datesep={/}]{datetime2}
\RequirePackage{xparse}
\RequirePackage{typearea}
\RequirePackage{eso-pic}
\RequirePackage{setspace}

% Conditional loading for minted (LOC-5 Rule 15)
\IfFileExists{minted.sty}{%
    \RequirePackage[newfloat,outputdir=.aux]{minted}%
}{%
    \ClassWarning{Veritas}{minted package not found; code highlighting disabled}%
}

\RequirePackage{silence}
\RequirePackage{fontawesome5}
\RequirePackage{calc}
\RequirePackage{soul}
\RequirePackage{mfirstuc}
\RequirePackage{adjustbox}
\RequirePackage{pagecolor}
\RequirePackage{tikz}
\usetikzlibrary{positioning}
\RequirePackage{psvectorian}
\RequirePackage{blindtext}
\RequirePackage{float}
\RequirePackage{pdflscape}

\tcbuselibrary{most}
\WarningsOff[blindtext]

%%% Configure siunitx %%%
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

%%% Import Configurations %%%
\usepackage{Configuration/00-Fonts}
\usepackage{Configuration/01-Colors}
\usepackage{Configuration/02-Margins}
\usepackage{Configuration/03-References}
\usepackage{Configuration/04-Headers}
\usepackage{Configuration/05-Contents}
\usepackage{Configuration/06-Glossary}
\usepackage{Configuration/07-Chapters}
\usepackage{Configuration/08-Tables}
\usepackage{Configuration/09-Code}
\usepackage{Configuration/10-Macros}
\usepackage{Configuration/11-Metadata}
\usepackage{Configuration/12-Floats}
\usepackage{Configuration/13-Mathematics}

