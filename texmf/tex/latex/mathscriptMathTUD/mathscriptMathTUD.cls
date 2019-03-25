% This work is licensed under the Creative Commons
% Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy
% of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or
% send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

% (c) Eric Kunze, 2019

% inspired by Henry Haustein, Daniel Graeveling
% https://github.com/henrydatei/TUD_MATH_BA

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{mathscriptMathTUD}[2018/08/05]

% programming related packages
\RequirePackage{zref-base}
\RequirePackage{etoolbox}
\RequirePackage{xparse}	% better macros
\RequirePackage{calc}
\RequirePackage{xstring}
\RequirePackage{xkeyval}
\RequirePackage{xifthen}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          TITLE STYLES                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% default settings
\newcommand{\chapstyle}{}
\newcommand{\secstyle}{}
\newcommand{\titlefont}{}

% >>
% Kapitel * \\ Titel
\newcommand{\brokenchapterstyle}{%
    \titleformat{\chapter}[display]{\bfseries\titlefont\color{cddarkblue}}{\LARGE \chaptername\;\thechapter}{-12pt}{\Huge\MakeUppercase}%
    \titlespacing{\chapter}{0pt}{0pt}{10pt}%
}

% >>
% like break but additionally framed
\newcommand{\framedchapterstyle}{%
    \titleformat{\chapter}[frame]{\bfseries\titlefont\color{cddarkblue}}{\enskip \LARGE \chaptername\;\thechapter \enskip}{8pt}{\Huge\centering\MakeUppercase}%
    \titlespacing{\chapter}{0pt}{0pt}{10pt}%
}


% >>
% chapter.section
\newcommand{\dotlesssectionsstyle}{%
    \counterwithout{section}{chapter}%
    \titleformat*{\section}{\bfseries\titlefont\LARGE}%{\thesection}{8pt}{}%
    \titleformat*{\subsection}{\bfseries\titlefont\Large}
}

% >>
% section.
\newcommand{\dottedsectionstyle}{%
    \renewcommand{\thechapter}{\Roman{chapter}}
    \titlelabel{\thetitle.\quad} % "." behind section/sub... (3. instead of 3)
    \counterwithout{section}{chapter}%
    \titleformat*{\section}{\bfseries\titlefont\LARGE}%{\thesection}{8pt}{}%
    \titleformat*{\subsection}{\bfseries\titlefont\Large}
}

% >>
% section
\newcommand{\puresectionstyle}{%
    % \titlelabel{\thetitle \quad} % "." behind section/sub... (3. instead of 3)
    %\titleformat{\section}[hang]{\bfseries\titlefont\LARGE}{\thesection}{8pt}{}%
    \titleformat*{\section}{\bfseries\titlefont\LARGE}
    \titleformat*{\subsection}{\bfseries\titlefont\Large}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             OPTIONS                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% >> reset section counter after each chapter or not
\newif\ifreset@section@after@chapter
\reset@section@after@chapterfalse
\DeclareOptionX{sectionreset}{%
	\reset@section@after@chaptertrue%
}

\newif\ifreset@equation@after@section
\reset@equation@after@sectionfalse
\DeclareOptionX{equationreset}{%
    \reset@equation@after@sectiontrue%
}

\newif\ifequation@without@section
\equation@without@sectionfalse
\DeclareOptionX{equationwithoutsection}{%
    \equation@without@sectiontrue%
}
\DeclareOptionX*{\PassOptionsToClass{\CurrentOption}{report}}

% >> define title styles

\DeclareOptionX{titlefont}{%
    \ifthenelse{\equal{#1}{osfamily}}%
        {\renewcommand{\titlefont}{\osfamily}}%
        {\PackageWarning{mathscriptMathTUD}{Unknown Value for key `titlefont'}%
        }%
}

\DeclareOptionX{chapterstyle}{%
    \ifthenelse{\equal{#1}{break}}%
        {\renewcommand{\chapstyle}{\brokenchapterstyle}}
        { \ifthenelse{\equal{#1}{framed}}%
            {\renewcommand{\chapstyle}{\framedchapterstyle}}
            {\PackageWarning{mathscriptMathTUD}{Unknown Value for key `chapterstyle'}}%
        }%
}

\DeclareOptionX{sectionstyle}{%
    \ifthenelse{\equal{#1}{dotless}}%
    {\renewcommand{\secstyle}{\dotlesssectionsstyle}} % then
    { \ifthenelse{\equal{#1}{dotted}}%						% else
        {\renewcommand{\secstyle}{\dottedsectionstyle}}
        {\ifthenelse{\equal{#1}{pure}}%						% else
            {\renewcommand{\secstyle}{\puresectionstyle}}
            {\PackageWarning{mathscriptMathTUD}{Unknown Value for key `sectionstyle'}%
            }%
        }%
    }%
}

\ProcessOptionsX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     GENERAL DOCUMENT SETTINGS                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\LoadClass[ngerman,a4paper]{report}

\RequirePackage[top=2.5cm,bottom=2.5cm,left=2.5cm,right=2.5cm]{geometry}
% \RequirePackage[left=2.1cm,right=3.1cm,bottom=3cm,footskip=0.75cm,headsep=0.5cm]{geometry}
% decent space; change explicitly the space between header and content and footer and content

\RequirePackage{ifpdf,ifluatex}
\ifpdf
	\ifluatex
		% new lualatex needs explicit fontspec to draw properly e.g. german umlauts
		\RequirePackage{fontspec}
		% \RequirePackage{lua-visual-debug} %for debugging
	\else
		% old pdflatex needs explicitly utf-8-support
		\RequirePackage[utf8]{inputenc}
		\RequirePackage{chngcntr}
		\RequirePackage{eufrak}
	\fi
\fi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           PACKAGES                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage[ngerman]{babel}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Layout related packages
\RequirePackage{tocloft}	% customize toc
\RequirePackage{parskip}  	% split paragraphs by vspace instead of intendations
% (done) parskip not recommended in KOMA-Script
\RequirePackage{fancyhdr} 	% customize header / footer
% (done) fancyhdr not recommended in KOMA-Script
\RequirePackage{titlesec} 	% customize titles
% (done) titlesec not recommended in KOMA-Script


%tabulars
\RequirePackage{tabularx} 	% tabularx-environment (explicitly set width of columns)
\RequirePackage{longtable} 	% Tabellen mit Seitenumbrüchen
\RequirePackage{multirow}
\RequirePackage{booktabs}	% improved rules
\usepackage{colortbl} 		% Einfärben von Spalten, Zeilen und Zellen

\RequirePackage[title,titletoc]{appendix}

\RequirePackage{environ}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% New font OpenSans included
\RequirePackage[scale=0.9]{opensans}
\newcommand*{\osfamily}{\fontfamily{fos}\selectfont}
\DeclareTextFontCommand{\textos}{\osfamily}
% for more informations: https://tex.stackexchange.com/questions/25249/how-do-i-use-a-particular-font-for-a-small-section-of-text-in-my-document


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% math related packages
% basic ams-math and enhancments
\RequirePackage{amsmath,amssymb,amsfonts,mathtools}
\RequirePackage{blkarray}


% add some font-related stuff
\RequirePackage{lmodern}
\RequirePackage{latexsym}
\RequirePackage{marvosym} 	% lightning (contradiction)
\RequirePackage{stmaryrd} 	% Lightning symbol
\RequirePackage{bbm} 		% unitary matrix
\RequirePackage{wasysym}	% add some symbols
% \RequirePackage[bb=boondox]{mathalfa} %special zero using \mathbb{0}
\RequirePackage{systeme}	% easy typesetting systems of equations

% further support for different equation setting
\RequirePackage{cancel}
\RequirePackage{xfrac}		% sfrac -> fractions e.g. 3/4
\RequirePackage{nicefrac}
\RequirePackage{units}		% units and fractions

\RequirePackage[amsthm,thmmarks,hyperref]{ntheorem}
\RequirePackage[ntheorem,framemethod=TikZ]{mdframed}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% graphics-related packages
\RequirePackage[table,dvipsnames]{tudscrcolor} 
%\RequirePackage[table,dvipsnames]{xcolor}
% official colours in cooperate design TUD
% (done) define colours -- use official tud colours
% main colours:
% cddarkblue, cdblue, cdgray, cdindigo, cdpurple, cddarkgreen, cdgreen, cdorange


\RequirePackage{graphicx}
\RequirePackage{tcolorbox}

\RequirePackage{pgfplots}
\pgfplotsset{compat=1.10} % in my packages used compat=1.15
\usepgfplotslibrary{fillbetween}
\RequirePackage{pgf}
\RequirePackage{tikz}
\usetikzlibrary{patterns,arrows,calc,decorations.pathmorphing,backgrounds, positioning,fit,petri,decorations.fractals}
\usetikzlibrary{matrix}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% text-related packages
% increase line spacing
\RequirePackage[onehalfspacing]{setspace} % increase row-space
\RequirePackage{ulem} 		% better underlines
\RequirePackage{marginnote}	% notes at the edge

% enumeration
\RequirePackage{enumerate}
\RequirePackage[inline]{enumitem} 		%customize label

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          HYPERLINKS                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% (done) set hyperlink options correctly
\RequirePackage[unicode,bookmarks=true]{hyperref}
\hypersetup{
    % pdfborder={0 0 0}			% no boxed around links
    pdfborderstyle={/S/U/W 1},	% underlining insteas of boxes
    linkbordercolor=cdblue,
    urlbordercolor=cdblue
%	colorlinks,
%	citecolor=black,
%	filecolor=cddarkblue!80,
%	linkcolor=black,
%	urlcolor=cddarkblue!80
}

\RequirePackage{cleveref}
\RequirePackage{bookmark}		% pdf-bookmarks

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    TITLE & PAGESTYLE SETTINGS                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (done) change title's look
\renewcommand{\thepart}{\Alph{part}}

\chapstyle
\secstyle

% automatic reset of section after chapter ended when option 'sectionreset' is enabled
\ifreset@section@after@chapter
\pretocmd{\chapter}{\setcounter{section}{0}}{}{}
\fi

% automatic reset of equation counter in each section
\ifreset@equation@after@section
\pretocmd{\section}{\setcounter{equation}{0}}{}{}
\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table of contents

% change appearence of heading of toc: 0 space above, bold, titlefont, huge toc-heading
\renewcommand{\cftbeforetoctitleskip}{0pt}
\renewcommand{\cfttoctitlefont}{\titlefont\Huge\bfseries}
% change indentations due to width of capital roman numbers
\renewcommand{\cftchapnumwidth}{2em}
\renewcommand{\cftsecindent}{2em}
\renewcommand{\cftsecnumwidth}{2em}
\renewcommand{\cftsubsecindent}{4em}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pagestyles

% Add new page-style (just footer), patch \chapter command to use this page style
%\fancypagestyle{plainChapter}{%
%    \fancyhf{}%
%    \fancyfoot[C]{\thepage} %
%    \renewcommand{\headrulewidth}{0pt} % Line at the header invisible
%    \renewcommand{\footrulewidth}{0.4pt} % Line at the footer visible
%}
%
%% changes pagestyle; instead of empty page the normal footer is printed
%\patchcmd{\chapter}{\thispagestyle{plain}}{\thispagestyle{plainChapter}}{}{}

\pagestyle{plain}
\pagenumbering{arabic}

%% remember chapter-title in \leftmark and \rightmark
%\renewcommand{\chaptermark}[1]{%
%    \markboth{\chaptername
%        \ \thechapter:\ #1}{}}
%
%% remember section title in \leftmark
%\renewcommand{\sectionmark}[1]{%
%    \markright{\thesection.\ #1}{}}
%
%%change header:
%\renewcommand{\headrulewidth}{0.75pt}
%\renewcommand{\footrulewidth}{0.3pt}
%\lhead{\rightmark}%left: section-number. section-title
%\rhead{\leftmark}%right: chapter chapternumber: chapter-title

% remove page number from part{}-pages
\let\sv@endpart\@endpart
\def\@endpart{\thispagestyle{empty}\sv@endpart}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          ENUMERATIONS                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\renewcommand{\labelitemi}{\raisebox{1pt}{\scalebox{.6}{$\blacksquare$}}}
\renewcommand{\labelitemii}{$\vartriangleright$}
\renewcommand{\labelitemiii}{--}
% >> Variantionen des Dreiecks als Aufzählungszeichen
% $\blacktriangleright$
% $\vartriangleright$
% $\triangleright$

\renewcommand{\labelenumi}{(\arabic{enumi})}
\renewcommand{\labelenumii}{\alph{enumii}.}
\renewcommand{\labelenumiii}{\roman{enumiii}.}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            TITLEPAGE                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\name}{\hfill}
\newcommand{\matnr}{\hfill}
\newcommand{\modul}{\hfill}
\newcommand{\tutor}{\hfill}
\newcommand{\group}{\hfill}
\newcommand{\period}{\hfill}
\newcommand{\email}{\href{mailto:example@mail.com}{\ttfamily \hfill}}

\newcommand{\faculty}{\hfill}
\newcommand{\institute}{\hfill}
\newcommand{\professorship}{\hfill}
\newcommand{\lecturer}{\hfill}


\newcommand{\titlesettings}[1]{%
    \ifthenelse{\equal{#1}{dark}}{%
        \pagecolor{cddarkblue!90}%
        \color{white}%
    }{}%
    \raggedright%
    \osfamily%
    \setlength{\parindent}{0pt}%
}

\newcommand{\titleheading}[1]{%
    \hspace{-18.6mm} %
    \ifthenelse{\equal{#1}{dark}}%
    { %\color{white}%
        \includegraphics[scale=0.6]{TUD-white.pdf}}%
    {\includegraphics[scale=0.6]{TUD-blue.pdf}}
    \vspace{3mm} \hrule \vspace{-1mm}
    \small{\textbf{Fakultät \faculty} Institut für \institute, Professur für \professorship}
    \vspace{0.6mm} \hrule
}

\newcommand{\titletitle}[1][]{%
    \vspace{5cm}
    {\Huge\bfseries \MakeUppercase \modul \par}
    %
    \ifthenelse{\isempty{#1}}{}{
        \vspace{0.5cm}%
        {\Large \itshape #1} \\%
    }
    %
    \vspace{1.5cm}
    \textbf{{\Large \lecturer}} \\
    \vspace{0.5cm}
    {\large \period}
}

\newcommand{\titlefoot}{%
    \vfill%
    \begin{tabular}{lll}
        Autor  & : & \name \\
        E-Mail & : & \email \\
    \end{tabular}%
}

\NewDocumentCommand{\MakeTitle}{O{dark} O{}}{%
    \begin{titlepage}
        \ifthenelse{\equal{#1}{dark}}{%
            \titlesettings{dark}%
            \titleheading{dark}%
        }{%
            \titlesettings{light}%
            \titleheading{light}%
        }%
        \ifthenelse{\isempty{#2}}{%
            \titletitle
        }{%
            \titletitle[#2]
        }%
        \titlefoot%
    \end{titlepage}
    \nopagecolor
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\endinput
