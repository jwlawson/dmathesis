\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{dmathesis}[2016/01/01 Durham University Maths Thesis Format]

% New thesis template written by Steven Charlton, 
% based on the old template of M. Imran
% Example content taken also from M. Imran's template

% Where to find various stuff in this file
% --- Document class options 
% --- Main body of class 
% --- Page margins 
% --- Title, author, ... 
% --- Set headers and footers 
% --- Line spacing 
% --- Add to TOC automatically commands 
% --- Title page, and other front matter of the thesis 

% ------------------------------- %
% --- Document class options ---- %

% a4paper is explicitly defined when setting the
% page geometry below, so this is probably redundant...
\PassOptionsToClass{a4paper}{report}

% deal with draft/thesisdraft option
\newif\if@durham@dma@footerdebug\@durham@dma@footerdebugfalse
\newif\if@durham@dma@draftmode\@durham@dma@draftmodefalse
\DeclareOption{draft}{
  \@durham@dma@draftmodetrue
  \@durham@dma@footerdebugtrue
  \PassOptionsToClass{\CurrentOption}{report}
}
\DeclareOption{footerdebug}{
  \@durham@dma@footerdebugtrue
}
\DeclareOption{nofooterdebug}{
  \@durham@dma@footerdebugfalse
}
\newif\if@durham@dma@showframe\@durham@dma@showframefalse
\DeclareOption{showframe}{
  \@durham@dma@showframetrue
}
\newif\if@durham@dma@showkeys\@durham@dma@showkeysfalse
\DeclareOption{showkeys}{
  \@durham@dma@showkeystrue
}

\DeclareOption{thesisdraft}{
  \@durham@dma@draftmodetrue  
  \@durham@dma@showkeystrue
  \@durham@dma@showframetrue
  \PassOptionsToClass{draft}{report}
}

\newif\if@durham@dma@singlespacing\@durham@dma@singlespacingfalse
\DeclareOption{singlespacing}{
  \@durham@dma@singlespacingtrue
  \@durham@dma@halfspacingfalse
  \@durham@dma@doublespacingfalse
}
\newif\if@durham@dma@halfspacing\@durham@dma@halfspacingfalse
\DeclareOption{halfspacing}{
  \@durham@dma@singlespacingfalse
  \@durham@dma@halfspacingtrue
  \@durham@dma@doublespacingfalse
}
\newif\if@durham@dma@doublespacing\@durham@dma@doublespacingtrue
\DeclareOption{doublespacing}{
  \@durham@dma@singlespacingfalse
  \@durham@dma@halfspacingfalse
  \@durham@dma@doublespacingtrue
}
\newif\if@durham@dma@twoside\@durham@dma@twosidefalse
\DeclareOption{twoside}{
  \@durham@dma@twosidetrue
  \PassOptionsToClass{\CurrentOption}{report}
}
\newif\if@durham@dma@headerfloatpage\@durham@dma@headerfloatpagetrue
\DeclareOption{noheaderfloatpage}{
  \@durham@dma@headerfloatpagefalse
}
\DeclareOption{headerfloatpage}{
  \@durham@dma@headerfloatpagetrue
}
\newif\if@durham@dma@frontopenright\@durham@dma@frontopenrightfalse
\DeclareOption{frontopenright}{
  \@durham@dma@frontopenrighttrue
}
\newif\if@durham@dma@raggedtitles\@durham@dma@raggedtitlestrue
\DeclareOption{raggedtitles}{
  \@durham@dma@raggedtitlestrue
}
\DeclareOption{noraggedtitles}{
  \@durham@dma@raggedtitlesfalse
}
\newif\if@durham@dma@chaprunninghead\@durham@dma@chaprunningheadtrue
\DeclareOption{chaprunninghead}{
  \@durham@dma@chaprunningheadtrue
}
\DeclareOption{nochaprunninghead}{
  \@durham@dma@chaprunningheadfalse
}
% Default to 12pt font size
\newcommand\@dmathesisptsize{12pt}
\DeclareOption{12pt}{\renewcommand\@dmathesisptsize{12pt}}
\DeclareOption{11pt}{\renewcommand\@dmathesisptsize{11pt}}
\DeclareOption{10pt}{\renewcommand\@dmathesisptsize{10pt}}

% pass all other options to base class
\DeclareOption*{
  \PassOptionsToClass{\CurrentOption}{report}
}

\ProcessOptions\relax

\PassOptionsToClass{\@dmathesisptsize}{report}
\LoadClass{report}

% ---------------------------------------------------------- %
% ----------------- Main body of class --------------------- %

% In draft mode, use geometry to show the page margins, 
% and showkeys to show all labelling and cross referencing
\if@durham@dma@showframe
  \PassOptionsToPackage{showframe}{geometry}
\fi
\if@durham@dma@showkeys
  \RequirePackage{showkeys}
\fi

% This is used in some commands so things link properly when hyperref is used
% Define it so there are no compilation errors if hyperref is not used
\let\phantomsection\relax

% Package to include graphics for the university crest
\RequirePackage{graphicx}
% Ensure all figures are centered
\g@addto@macro\@floatboxreset\centering
% Provide option to set default float position
\providecommand*\setfloatlocations[2]{\@namedef{fps@#1}{#2}}

\RequirePackage{emptypage}

% ----------------------------------------- %
% ----------- Page margins ---------------- %

% Margin sizes are taken from university regulations available at
% https://www.dur.ac.uk/graduate.school/current-students/submissionandbeyond/thesis.submission/preparing.thesis/format/
% as of January 2016
\if@durham@dma@twoside
  \PassOptionsToPackage{twoside}{geometry}
\fi

% "The margin at the binding edge of the page should not be less than 40mm. Other margins should not be less than 15mm. Running heads and page numbers should be within the recommended margin."

% Load geometry package to set up page margins
\RequirePackage{geometry}

\geometry{a4paper,
%Header spacing included in top margin, so top must be at least 15mm
  includehead,
  top=15mm,
  headheight=1.3em,
%Footer spacing not included, so (bottom - footskip) must be at least 15mm
%  If no footers are used, then bottom could be set to 15mm if wished
  bottom=23mm,
  footskip=8mm,
%Spacing between text baseline and rule before footnote
  footnotesep=5mm,
%(Inner + bindingoffset) should be at least 40mm
%outer should be at least 15mm
  inner=30mm,
  outer=20mm,
  bindingoffset=10mm,
%Marginpar not included in spacing, so nothing should be included in the
%  margins in the final copy
  marginparwidth=25mm,
  reversemarginpar}


% ------------------------------------------------- %
% ------------------- Title, author, ... ---------- %

% Define some commands so we can automatically insert title, 
% author, research group, and date throughout the document
\renewcommand{\title}[1]{\renewcommand\dma@title{#1}}
\newcommand{\dmatitle}{\dma@title}
\newcommand\dma@title{}

\newcommand{\subtitle}[1]{\renewcommand\dma@subtitle{#1}}
\newcommand{\dmasubtitle}{\dma@subtitle}
\newcommand\dma@subtitle{}

\renewcommand{\author}[1]{\renewcommand\dma@author{#1}}
\newcommand{\dmaauthor}{\dma@author}
\newcommand\dma@author{}

% \today is defined as follows (!)
% \ifcase \month \or January\or February\or March\or April\or May\or June\or July\or August\or September\or October\or November\or December\fi \space \number \day , \number \year

% Modified version to only print month and year
\newcommand{\monthyear}{\ifcase \month \or January\or February\or March\or April\or May\or June\or July\or August\or September\or October\or November\or December\fi \space \number \year}

\renewcommand{\date}[1]{\renewcommand\dma@date{#1}}
\newcommand{\dmadate}{\dma@date}
% if no date specified, use current date
% normally month-year,
% but if in draft mode, include the day
\newcommand\dma@date{\monthyear}
\if@durham@dma@draftmode
  \renewcommand\dma@date{\today}
\fi

\newcommand{\researchgroup}[1]{\renewcommand\dma@researchgroup{#1}}
\newcommand{\dmaresearchgroup}{\dma@researchgroup}
\newcommand\dma@researchgroup{\@empty}

% ------------------------------------------------- %
% ------------ Set headers and footers ------------ %

\RequirePackage{fancyhdr}
\pagestyle{fancy}

\fancyhf{} % clear all header and footer fields
\renewcommand{\footrulewidth}{0pt}
\if@durham@dma@footerdebug
  \fancyfoot[R]{\footnotesize\ttfamily\dmadate} % in draft mode, display the date
\fi
\if@twoside
  \if@durham@dma@headerfloatpage
    \fancyhead[RO]{\bf\thepage}
    \fancyhead[LO]{\bf\nouppercase\rightmark}
    \fancyhead[RE]{\bf\nouppercase\leftmark}
    \fancyhead[LE]{\bf\thepage}
    \renewcommand{\headrulewidth}{1pt}
  \else
    \fancyhead[RO]{\iffloatpage{}{\bf\thepage}}
    \fancyhead[LO]{\iffloatpage{}{\bf\nouppercase\rightmark}}
    \fancyhead[RE]{\iffloatpage{}{\bf\nouppercase\leftmark}}
    \fancyhead[LE]{\iffloatpage{}{\bf\thepage}}
    \renewcommand{\headrulewidth}{\iffloatpage{0pt}{1pt}}
  \fi
\else
  \def\chaptermark#1{%
    \markright {\MakeUppercase{%
      \ifnum \c@secnumdepth >\m@ne
          \@chapapp\ \thechapter. \ %
      \fi
      #1}}}%
  \if@durham@dma@headerfloatpage
    \fancyhead[R]{\bf\thepage}
    \fancyhead[L]{\bf\nouppercase\rightmark}
    \renewcommand{\headrulewidth}{1pt}
  \else
    \fancyhead[R]{\iffloatpage{}{\bf\thepage}}
    \fancyhead[L]{\iffloatpage{}{\bf\nouppercase\rightmark}}
    \renewcommand{\headrulewidth}{\iffloatpage{0pt}{1pt}}
  \fi
\fi
\fancypagestyle{plain}{
  \fancyhf{} % clear all header and footer fields
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}
}

\if@durham@dma@chaprunninghead\else
  \if@twoside
    \def\chaptermark#1{%
      \markboth{\MakeUppercase{#1}}{}}%
  \else
    \def\chaptermark#1{%
      \markright{\MakeUppercase{#1}}}%
  \fi
\fi
% Original commands copied from report class
\if@durham@dma@raggedtitles
  \renewcommand\section{\@startsection{section}{1}{\z@}%
                                   {-3.5ex \@plus -1ex \@minus -.2ex}%
                                   {2.3ex \@plus.2ex}%
                                   {\raggedright\normalfont\Large\bfseries}}
  \renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
                                     {\raggedright\normalfont\large\bfseries}}
  \renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
                                     {\raggedright\normalfont\normalsize\bfseries}}
\fi

% -------------------------- %
% ------- Line spacing ----- %
\PassOptionsToPackage{nodisplayskipstretch}{setspace}
\RequirePackage{setspace}

\if@durham@dma@singlespacing
  \singlespacing
\fi
\if@durham@dma@halfspacing
  \onehalfspacing
\fi
\if@durham@dma@doublespacing
  \doublespacing
\fi

% -------------------------------------------- %
% ---- Add to TOC automatically commands ----- %

\renewcommand\@dotsep{8}
% define starred version of various commands, which will add/not add
% them automatically to the table of contents
\let\@durham@dma@tableofcontents\tableofcontents
\renewcommand{\tableofcontents}{\@ifstar\@durham@dma@tableofcontentsstar\@durham@dma@tableofcontentsnormal}
\newcommand{\@durham@dma@tableofcontentsstar}{\@durham@dma@tableofcontents}
\newcommand{\@durham@dma@tableofcontentsnormal}{
  \if@openright\cleardoublepage\else\clearpage\fi
  \phantomsection
  \addcontentsline{toc}{chapter}{\contentsname}
  \@durham@dma@tableofcontents
}

\let\@durham@dma@listoffigures\listoffigures
\renewcommand{\listoffigures}{\@ifstar\@durham@dma@listoffiguresstar\@durham@dma@listoffiguresnormal}
\newcommand{\@durham@dma@listoffiguresstar}{\@durham@dma@listoffigures}
\newcommand{\@durham@dma@listoffiguresnormal}{
  \if@openright\cleardoublepage\else\clearpage\fi
  \phantomsection
  \addcontentsline{toc}{chapter}{\listfigurename}
  \@durham@dma@listoffigures
}

\let\@durham@dma@listoftables\listoftables
\renewcommand{\listoftables}{\@ifstar\@durham@dma@listoftablesstar\@durham@dma@listoftablesnormal}
\newcommand{\@durham@dma@listoftablesstar}{\@durham@dma@listoftables}
\newcommand{\@durham@dma@listoftablesnormal}{
  \if@openright\cleardoublepage\else\clearpage\fi
  \phantomsection
  \addcontentsline{toc}{chapter}{\listtablename}
  \@durham@dma@listoftables
}

% --------------------------------------------------------------------- %
% -------- title page, and other front matter of the thesis ----------- %

% hyperref does some stuff with \maketitle, so don't use it
% clear the command, so it isn't used by accident
\let\maketitle\relax


% created starred versions of all these enviroments, which will add/not add
% them automatically to the table of contents
\newcommand{\maketitlepage}{\@ifstar\@durham@dma@maketitlestar\@durham@dma@maketitlenormal}
\newcommand{\@durham@dma@maketitlestar}{\@durham@dma@maketitle}
\newcommand{\@durham@dma@maketitlenormal}{\@durham@dma@maketitle[\@durham@dma@intoc]}


% create title page
% the \nointerlineskip commands are to ensure spaces inserted by 
% \vspace are consistent even if line-spacing is changed
\newcommand{\@durham@dma@maketitle}[1][\@empty]{
  \bgroup
  \pagestyle{empty}
  \thispagestyle{empty}
  \setlength{\parindent}{0pt}
  \setlength{\parskip}{0em}
  \markboth{}{}
  \ifx#1\@durham@dma@intoc
    \addcontentsline{toc}{chapter}{Title page}
  \fi
  \centering
  \null
  {\huge \bf \dmatitle \par}
  \if\relax\dmasubtitle\relax\else
    \vspace{1.5em}{\LARGE \emph \dmasubtitle \par}
  \fi
  \vspace{\stretch{1}}
  {\LARGE\dmaauthor\par}
  \vspace{\stretch{1}}
  {\large
    \setstretch{1.2}
    A Thesis presented for the degree of \\
    Doctor of Philosophy\par
    \nointerlineskip
    \vspace{1.5em}
    \includegraphics{img/durham_logo}\par
    \nointerlineskip
    \vspace{1.5em}
    % Don't write out research group if not set
    \if\relax\dma@researchgroup\relax\else
      \dmaresearchgroup{} \\
    \fi
    Department of Mathematical Sciences \\
    Durham University \\
    United Kingdom \\[1.0em]
    \dmadate\par}
  \null
  \egroup
  \clearpage
  \global\let\maketitlepage\relax
}

\def\dma@dedi@text{Dedicated to}
\providecommand{\dedicationtext}[1]{\renewcommand{\dma@dedi@text}{#1}}
\newenvironment{dedication}{\begin{dedication*}[\@durham@dma@intoc]}{\end{dedication*}}
\newenvironment{dedication*}[1][\@empty]{
  \if@openright\cleardoublepage\else\clearpage\fi
  \pagestyle{empty}
  \setstretch{1}
  \setlength{\parindent}{0pt}
  \setlength{\parskip}{0em}
  \ifx#1\@durham@dma@intoc
  \phantomsection
  \addcontentsline{toc}{chapter}{Dedication}
  \fi
  \markboth{Dedication}{Dedication}
  \bgroup
    \newcommand{\also}[1][Also to]{
      \par
      \vspace{4em}
      {\LARGE\itshape ##1 \par}
      \nointerlineskip
      \vspace{3em}
    }
  \topskip0pt
  \centering
  \nointerlineskip
  \vspace*{\stretch{1}}
  \begin{minipage}[c]{0.5\textwidth}
  \centering
  {\LARGE\itshape\dma@dedi@text\par}
  \large
  \nointerlineskip
  \vspace{3em}
}{
  \end{minipage}
  \vspace*{\stretch{2}}
  \par\egroup
  \clearpage
}
\def\dma@epi@width{0.77\textwidth}
\providecommand{\epigraphpagewidth}[1]{\renewcommand{\dma@epi@width}{#1}}
\def\dma@epi@sourcesep{2em}
\providecommand{\epigraphsourcesep}[1]{\renewcommand{\dma@epi@sourcesep}{#1}}
\newenvironment{epigraph}{\begin{epigraph*}[\@durham@dma@intoc]}{\end{epigraph*}}
\newenvironment{epigraph*}[1][\@empty]{
  \if@openright\cleardoublepage\else\clearpage\fi
  \pagestyle{empty}
  \setstretch{1}
  \setlength{\parindent}{0pt}
  \setlength{\parskip}{0em}
  \ifx#1\@durham@dma@intoc
    \phantomsection
    \addcontentsline{toc}{chapter}{Epigraph}
  \fi
  \markboth{}{}
  \bgroup
  \centering
  \vspace*{\stretch{1}}
  \begin{minipage}{\dma@epi@width}
  \newcommand{\source}[2]{
    \par\vspace*{\dma@epi@sourcesep}
    \begin{minipage}{\textwidth}\begin{flushright}
    \normalsize\normalfont
    \if\relax\detokenize{##1}\relax
      \if\relax\detokenize{##2}\relax\else
        --- ##2
      \fi
    \else
      --- from \textit{##1}
      \if\relax\detokenize{##2}\relax\else
        by ##2
      \fi
    \fi
    \end{flushright}\end{minipage}\par\vspace*{5em}}
  \def\baselinestretch{1.4}
  \normalsize\em
}{
  \end{minipage}
  \vspace*{\stretch{2}}
  \par\egroup
  \clearpage
}

\renewenvironment{abstract}{\begin{abstract*}[\@durham@dma@intoc]}{\end{abstract*}}
\newenvironment{abstract*}[1][\@empty]{
  \if@openright\cleardoublepage\else\clearpage\fi
  \pagestyle{empty}
  \ifx#1\@durham@dma@intoc
    \phantomsection
    \addcontentsline{toc}{chapter}{\abstractname}
  \fi
  \if@twoside
    \markboth{\abstractname}{\abstractname}
  \else
    \markright{\abstractname}
  \fi
  \bgroup
    \setlength{\parindent}{0pt}
    \setlength{\parskip}{0em}
    \centering
    \null
    % Restrict title width to give same linebreaks as in titlepage
    \begin{minipage}[c]{.8\textwidth} 
    \centering{\LARGE\bf\dmatitle\par}
    \if\relax\dmasubtitle\relax\else
      \vspace{1.0em}{\Large\emph\dmasubtitle\par}
    \fi
    \end{minipage}
    \par\nointerlineskip
    {\LARGE\vspace{2em}}
    {\Large \dmaauthor\par}
    \nointerlineskip
    {\LARGE\vspace{2em}}
    {\large
      Submitted for the degree of Doctor of Philosophy \\
      \dmadate\par
    }
    \nointerlineskip
    {\LARGE\vspace{2em}}
  \egroup
  \vspace{-\parskip}
  \par\noindent{\bf \abstractname:}
}
{
  \clearpage
}

\if@durham@dma@frontopenright
  \let\chapterlike\chapter
\else
% Provide a chapterlike command which does everything a chapter does, except
% force a clear double page when openright is specified.
\newcommand\chapterlike{%
  \thispagestyle{plain}%
  \global\@topnum\z@
  \@afterindentfalse
  \secdef\@chapter\@schapter}
\fi

\newenvironment{declaration}{\begin{declaration*}[\@durham@dma@intoc]}{\end{declaration*}}
\newenvironment{declaration*}[1][\@empty]{
  \chapterlike*{Declaration}
  \if@twoside
    \markboth{Declaration}{Declaration}
  \else
    \markright{Declaration}
  \fi
  \ifx#1\@durham@dma@intoc
    \addcontentsline{toc}{chapter}{Declaration}
  \fi
}{
  %\par\vspace{2cm}
  \par\vfill
  \noindent \textbf{Copyright \copyright{} \number\year\space \dmaauthor}.\\
  ``The copyright of this thesis rests with the author. No quotation from it
  should be published without the author's prior written consent and information
  derived from it should be acknowledged.''
  \clearpage
}

\newenvironment{acknowledgements}{\begin{acknowledgements*}[\@durham@dma@intoc]}{\end{acknowledgements*}}
\newenvironment{acknowledgements*}[1][\@empty]{
  \chapterlike*{Acknowledgements}
  \if@twoside
    \markboth{Acknowledgements}{Acknowledgements}
  \else
    \markright{Acknowledgements}
  \fi
  \ifx#1\@durham@dma@intoc
    \addcontentsline{toc}{chapter}{Acknowledgements}
  \fi
}{
  \clearpage
}

\endinput
