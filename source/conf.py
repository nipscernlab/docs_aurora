import os
from pathlib import Path

docs_root = Path(__file__).resolve().parent.parent

project = "AURORA"
author = "NIPSCERN / documentação técnica"
copyright = "2026, NIPSCERN"
version = "6.3.2"
release = "6.3.2 (commit cee4922)"

extensions = [
    "myst_parser",
    "sphinx_design",
    "sphinx_copybutton",
    "sphinxcontrib.mermaid",
    "sphinx.ext.autosectionlabel",
    "sphinx.ext.extlinks",
]

myst_enable_extensions = [
    "colon_fence",
    "deflist",
    "fieldlist",
    "substitution",
    "tasklist",
]
myst_heading_anchors = 4
autosectionlabel_prefix_document = True

templates_path = ["_templates"]
pdf_build = os.environ.get("AURORA_PDF_BUILD") == "1"
root_doc = "pdf-index" if pdf_build else "index"
exclude_patterns = ["index.md"] if pdf_build else ["pdf-index.md"]
language = "pt_BR"

# Alvo do HTML:
#
#   local    conferencia na propria maquina.
#   web      publicado no branch gh-pages e servido em nipscern.com/docs/sapho
#            por um Worker.
#   offline  empacotado dentro da AURORA, sem depender de rede: os diagramas
#            sao pre-renderizados em SVG.
#
# O PDF acompanha o site nos tres casos, sempre em _static/downloads, para que
# exista um unico publicador: quem gera o HTML gera tambem o manual ao lado.
docs_target = os.environ.get("AURORA_DOCS_TARGET", "local")
pdf_name = "AURORA-Manual-6.3.2.pdf"
pdf_url = f"_static/downloads/{pdf_name}"

if docs_target == "web":
    html_baseurl = "https://www.nipscern.com/docs/sapho/"

if docs_target == "offline":
    # Sem isto o Mermaid renderiza no navegador, buscando o script no
    # cdn.jsdelivr.net. O mermaid-cli desenha em SVG durante o build e a pagina
    # passa a mostrar uma imagem, sem depender de JavaScript nem de rede.
    mermaid_output_format = "svg"

# O botao vai inteiro na substituicao, em uma linha so: o MyST nao expande
# substituicoes dentro de um bloco HTML, apenas em paragrafo de texto.
pdf_button = (
    f'<a class="pdf-download-button" href="{pdf_url}" download="{pdf_name}">'
    '<span class="pdf-download-title">Baixar manual em PDF</span>'
    '<span class="pdf-download-meta">Documento completo em formato A4</span>'
    "</a>"
)

myst_substitutions = {
    "pdf_url": pdf_url,
    "pdf_name": pdf_name,
    "pdf_button": pdf_button,
}

html_theme = "furo"
html_title = "AURORA 6.3.2 — Manual completo"
html_static_path = ["_static"]
html_css_files = ["css/aurora.css"]
html_js_files = ["js/aurora.js"]
html_logo = "_static/aurora.svg"
html_favicon = "_static/aurora.svg"
html_theme_options = {
    "light_css_variables": {
        "color-brand-primary": "#374151",
        "color-brand-content": "#365b78",
        "color-background-primary": "#ffffff",
        "color-background-secondary": "#f4f5f7",
        "color-sidebar-background": "#f7f7f8",
        "color-sidebar-background-border": "#d9dde3",
    },
    "dark_css_variables": {
        "color-brand-primary": "#d1d5db",
        "color-brand-content": "#aebdca",
        "color-background-primary": "#111318",
        "color-background-secondary": "#181b21",
        "color-sidebar-background": "#15181d",
        "color-sidebar-background-border": "#2a2f38",
    },
    "footer_icons": [],
}

html_context = {
    "default_mode": "light",
}

copybutton_prompt_text = r">>> |\.\.\. |\$ |PS [^>]*> "
copybutton_prompt_is_regexp = True

mermaid_version = "11.4.1"
mermaid_init_js = "mermaid.initialize({startOnLoad:true, theme:'neutral', securityLevel:'loose'});"
mermaid_cli = docs_root / "node_modules" / "@mermaid-js" / "mermaid-cli" / "src" / "cli.js"
mermaid_puppeteer_config = docs_root / "mermaid-puppeteer-config.json"
mermaid_cmd = f'node.exe "{mermaid_cli}"'
mermaid_pdfcrop = str(docs_root / "scripts" / "pdfcrop-mermaid.cmd")
mermaid_params = [
    "--puppeteerConfigFile",
    str(mermaid_puppeteer_config),
    "--theme",
    "neutral",
    "--backgroundColor",
    "transparent",
]

latex_engine = "xelatex"
latex_logo = "_static/aurora-logo-pdf.png"
latex_documents = [
    (
        "pdf-index",
        "AURORA-Manual-6.3.2.tex",
        "AURORA 6.3.2 — Manual completo",
        "NIPSCERN",
        "manual",
    ),
]
latex_show_urls = "footnote"
latex_elements = {
    "papersize": "a4paper",
    "pointsize": "10pt",
    "extraclassoptions": "oneside,openany",
    "fontpkg": r"""
\setmainfont{Segoe UI}
\setsansfont{Segoe UI}
\setmonofont{Cascadia Mono}[
  Scale=0.82,
  BoldFont={Cascadia Mono},
  ItalicFont={Cascadia Mono},
  BoldItalicFont={Cascadia Mono},
  BoldFeatures={FakeBold=1.5},
  ItalicFeatures={FakeSlant=0.2},
  BoldItalicFeatures={FakeBold=1.5,FakeSlant=0.2}
]
""",
    "fncychap": "",
    "geometry": r"""
\usepackage[
  a4paper,
  left=22mm,
  right=22mm,
  top=25mm,
  bottom=24mm,
  headheight=15pt,
  headsep=7mm,
  footskip=11mm
]{geometry}
""",
    "contentsname": r"\renewcommand{\contentsname}{Sumário}",
    "figure_align": "htbp",
    "maketitle": r"""
\hypersetup{pageanchor=false}
\begin{titlepage}
  \thispagestyle{empty}
  \color{AuroraInk}
  \vspace*{10mm}
  \begin{flushleft}
    \sphinxincludegraphics[width=42mm]{aurora-logo-pdf.png}

    \vfill

    {\color{AuroraRule}\rule{\textwidth}{1.4pt}}\par
    \vspace{9mm}
    {\fontsize{36}{40}\selectfont\bfseries\sffamily AURORA\par}
    \vspace{4mm}
    {\fontsize{20}{25}\selectfont\sffamily Manual de uso e referência técnica\par}
    \vspace{7mm}
    {\large\color{AuroraMuted} Versão 6.3.2\par}

    \vfill

    {\small\sffamily
      \textbf{NIPSCERN}\par
      Núcleo de Inovação e Pesquisa em Sistemas Computacionais\par
      \vspace{2mm}
      Junho de 2026\par
    }
  \end{flushleft}
\end{titlepage}
\clearpage
\hypersetup{pageanchor=true}
""",
    "preamble": r"""
% A partir do array 2026/02/24 o colortbl passa a usar os ganchos novos de linha
% e deixa de criar o registro proprio de \everycr. O Sphinx 9.1.0 ainda grava
% \the\everycr dentro de \CT@everycr para colorir as linhas alternadas, o que
% se torna autorreferente e estoura a pilha do TeX em toda tabela do manual.
% Este trecho restaura o arranjo antigo esperado pelo Sphinx e pode ser removido
% quando o Sphinx corrigir a incompatibilidade.
\makeatletter
\@ifpackageloaded{colortbl}{%
  \ifx\CT@everycr\everycr
    \RemoveFromHook{tbl/row/end}[colortbl]%
    \RemoveFromHook{tbl/row/init}[colortbl]%
    \newtoks\everycr
    \CT@everycr{\noalign{\global\let\CT@row@color\relax}\the\everycr}%
  \fi
}{}
\makeatother
\usepackage{microtype}
\usepackage{titlesec}
\usepackage{caption}
\usepackage{enumitem}
\definecolor{AuroraInk}{HTML}{20242A}
\definecolor{AuroraMuted}{HTML}{5F6873}
\definecolor{AuroraRule}{HTML}{7C8794}
\definecolor{AuroraSoft}{HTML}{F2F4F6}
\definecolor{AuroraSoftAlt}{HTML}{F8F9FA}
\definecolor{AuroraBorder}{HTML}{D5DAE0}
\definecolor{AuroraLink}{HTML}{365B78}
\definecolor{sphinx-warning-title-bgcolor}{HTML}{E8EAED}
\definecolor{sphinx-warning-title-fgcolor}{HTML}{374151}
\definecolor{sphinx-note-title-bgcolor}{HTML}{E8EAED}
\definecolor{sphinx-note-title-fgcolor}{HTML}{374151}
\definecolor{sphinx-success-title-bgcolor}{HTML}{E8EAED}
\definecolor{sphinx-success-title-fgcolor}{HTML}{374151}
\definecolor{sphinx-error-title-bgcolor}{HTML}{E2E4E7}
\definecolor{sphinx-error-title-fgcolor}{HTML}{20242A}
\definecolor{sphinx-todo-title-bgcolor}{HTML}{E8EAED}
\definecolor{sphinx-todo-title-fgcolor}{HTML}{374151}
\setlength{\parskip}{0.58em plus 0.12em minus 0.08em}
\setlength{\parindent}{0pt}
\linespread{1.04}
\setlist{topsep=0.35em,itemsep=0.18em,parsep=0.1em,leftmargin=1.7em}
\captionsetup{
  font=small,
  labelfont={bf,color=AuroraInk},
  textfont={color=AuroraMuted},
  justification=raggedright,
  singlelinecheck=false,
  skip=7pt
}
\titleformat{\part}[display]
  {\thispagestyle{empty}\normalfont\sffamily\color{AuroraInk}}
  {\filleft\fontsize{15}{18}\selectfont\color{AuroraMuted}\partname\ \thepart}
  {8mm}
  {\titlerule[1.2pt]\vspace{8mm}\fontsize{30}{35}\selectfont\bfseries}
\titlespacing*{\part}{0pt}{35mm}{0pt}
\titleformat{\chapter}[display]
  {\normalfont\sffamily\color{AuroraInk}}
  {\fontsize{12}{15}\selectfont\bfseries\color{AuroraMuted}\chaptername\ \thechapter}
  {2mm}
  {\titlerule[0.8pt]\vspace{5mm}\fontsize{25}{30}\selectfont\bfseries}
\titlespacing*{\chapter}{0pt}{-8mm}{12mm}
\titleformat{\section}
  {\Large\bfseries\sffamily\color{AuroraInk}}
  {\thesection}{0.7em}{}
\titleformat{\subsection}
  {\large\bfseries\sffamily\color{AuroraInk}}
  {\thesubsection}{0.7em}{}
\titleformat{\subsubsection}
  {\normalsize\bfseries\sffamily\color{AuroraInk}}
  {\thesubsubsection}{0.7em}{}
\titlespacing*{\section}{0pt}{2.2em}{0.65em}
\titlespacing*{\subsection}{0pt}{1.7em}{0.45em}
\titlespacing*{\subsubsection}{0pt}{1.35em}{0.35em}
\renewcommand{\chaptermark}[1]{\markboth{#1}{}}
\renewcommand{\sectionmark}[1]{\markright{#1}}
\fancypagestyle{normal}{
  \fancyhf{}
  \fancyhead[L]{\small\sffamily\color{AuroraMuted}AURORA 6.3.2}
  \fancyhead[R]{\small\sffamily\color{AuroraMuted}\nouppercase{\leftmark}}
  \fancyfoot[L]{\scriptsize\sffamily\color{AuroraMuted}NIPSCERN}
  \fancyfoot[R]{\small\sffamily\color{AuroraInk}\thepage}
  \renewcommand{\headrulewidth}{0.35pt}
  \renewcommand{\footrulewidth}{0pt}
}
\fancypagestyle{plain}{
  \fancyhf{}
  \fancyfoot[L]{\scriptsize\sffamily\color{AuroraMuted}NIPSCERN}
  \fancyfoot[R]{\small\sffamily\color{AuroraInk}\thepage}
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}
}
\hypersetup{
  colorlinks=true,
  linkcolor=AuroraLink,
  urlcolor=AuroraLink,
  citecolor=AuroraLink,
  pdfdisplaydoctitle=true,
  pdfpagelayout=SinglePage,
  pdfpagemode=UseOutlines
}
""",
    "sphinxsetup": r"""
TitleColor={HTML}{20242A},
InnerLinkColor={HTML}{374151},
OuterLinkColor={HTML}{374151},
VerbatimColor={HTML}{F2F4F6},
VerbatimBorderColor={HTML}{D5DAE0},
TableRowColorHeader={HTML}{E4E8EC},
TableRowColorOdd={HTML}{F5F6F8},
TableRowColorEven={HTML}{FFFFFF},
div.note_border-TeXcolor={HTML}{AEB6BF},
div.note_background-TeXcolor={HTML}{F8F9FA},
div.note_title-background-TeXcolor={HTML}{E8EAED},
div.note_title-foreground-TeXcolor={HTML}{374151},
div.hint_border-TeXcolor={HTML}{AEB6BF},
div.hint_background-TeXcolor={HTML}{F8F9FA},
div.hint_title-background-TeXcolor={HTML}{E8EAED},
div.hint_title-foreground-TeXcolor={HTML}{374151},
div.tip_border-TeXcolor={HTML}{AEB6BF},
div.tip_background-TeXcolor={HTML}{F8F9FA},
div.tip_title-background-TeXcolor={HTML}{E8EAED},
div.tip_title-foreground-TeXcolor={HTML}{374151},
div.seealso_title-background-TeXcolor={HTML}{E8EAED},
div.seealso_title-foreground-TeXcolor={HTML}{374151},
div.todo_title-background-TeXcolor={HTML}{E8EAED},
div.todo_title-foreground-TeXcolor={HTML}{374151},
div.important_title-background-TeXcolor={HTML}{E8EAED},
div.important_title-foreground-TeXcolor={HTML}{374151},
div.caution_title-background-TeXcolor={HTML}{E8EAED},
div.caution_title-foreground-TeXcolor={HTML}{374151},
div.warning_title-background-TeXcolor={HTML}{E8EAED},
div.warning_title-foreground-TeXcolor={HTML}{374151},
div.attention_title-background-TeXcolor={HTML}{E2E4E7},
div.attention_title-foreground-TeXcolor={HTML}{20242A},
div.danger_title-background-TeXcolor={HTML}{E2E4E7},
div.danger_title-foreground-TeXcolor={HTML}{20242A},
div.error_title-background-TeXcolor={HTML}{E2E4E7},
div.error_title-foreground-TeXcolor={HTML}{20242A}
""",
}

extlinks = {
    "repo": ("https://github.com/nipscernlab/aurora/%s", "%s"),
    "nipscern": ("https://nipscern.com/%s", "%s"),
}

rst_prolog = """
.. |snapshot| replace:: AURORA 6.3.2 (`cee4922`)
"""

nitpicky = False
suppress_warnings = ["myst.header"]
