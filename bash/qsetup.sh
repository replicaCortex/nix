set -e

if [ ! -f shell.nix ]; then
  cat >>shell.nix <<EOF
{
  pkgs ? import <nixpkgs> {},
  mode ? "dev",
}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    python312Packages.uv
    zlib
    gcc
    librsvg
    graphviz
  ];

  shellHook =
    if mode != "preview"
    then ''
      alias m="quarto render index.qmd"
      alias p="zen http://localhost:8080"
      alias z="zathura _book/*.pdf"
    ''
    else ''
      export LD_LIBRARY_PATH="\${pkgs.zlib}/lib:\$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="\${pkgs.stdenv.cc.cc.lib.outPath}/lib:\$LD_LIBRARY_PATH"

      export UV_VENV_CLEAR=1

      uv venv
      source .venv/bin/activate
      uv pip install -r requirements.txt
      uv pip freeze >| requirements.txt

      python -m ipykernel install --user --name 'quarto' --display-name "quarto jupyter"

      alias q='quarto preview index.qmd --port 8080 --no-browser'

      q

      trap 'rm -rf "\$HOME/.ipython"; rm -rf "\$HOME/.local/share/jupyter"; rm -rf "\$HOME/.cache/matplotlib"; rm -rf "\$HOME/.cache/jedu"; rm -rf ./.venv; rm -rf "\$HOME/.compose-cache"; rm -rf "\$HOME/.cache/deno";  rm -rf "\$HOME/.config/matplotlib/"; rm -rf "\$HOME/.jupyter"'  EXIT
    '';
}
EOF
fi

if [ ! -f _quarto.yml ]; then
  cat >>_quarto.yml <<EOF
execute:
  echo: false

project:
  type: book

jupyter: quarto

fig-pos: "H"
tbl-pos: "H"
lst-pos: "H"

book:
  chapters:
    - index.qmd

bibliography: bib.bib
csl: gost-r-7-0-5-2008-numeric-alphabetical.csl

nocite: |
  @*

number-sections: false
highlight-style: github
code-line-numbers: true

format:
  docx:
    reference-doc: template.docx
    toc: false
  html:
    number-chapters: false
    toc: false
    css: jupyter.css
  # pdf:
  #   pdf-engine: lualatex
  #   mainfont: "Ubuntu"
  #   monofont: "Ubuntu mono"
  #   sansfont: "Ubuntu"
  #   toc: false
  #   header-includes: |
  #     \usepackage{etoolbox}
  #     \patchcmd{\chapter}{\cleardoublepage}{}{}{}
lang: ru
EOF
fi

if [ ! -f jupyter.css ]; then
  cat >>jupyter.css <<EOF
#quarto-content {
  margin: 2rem auto;
  padding: 0 2rem;
}

h1,
h2,
h3,
h4,
h5,
h6 {
  border-bottom: 1px solid;
}

a {
  text-decoration: none;
}

a:hover {
  text-decoration: underline;
}

.cell-output-stdout pre,
.cell-output-stderr pre {
  font-family:;
  font-size: 0.9em;
  white-space: pre-wrap;
  word-wrap: break-word;
  padding: 0.5em;
  background: none;
  border: none;
  margin: 0;
}

#quarto-content p,
#quarto-content li {
  text-align: justify;
  hyphens: auto;
}
EOF
fi

echo "ipykernel" >requirements.txt
touch index.qmd
touch bib.bib
mkdir resources
mkdir src
cp ~/nix/**/template.docx .
cp ~/nix/**/gost-r-7-0-5-2008-numeric-alphabetical.csl .

# -- git ---

git init -q
git branch -m main -q

if [ ! -f .gitignore ]; then
  cat >>.gitignore <<EOF
.quarto
__pycache__
_book
*.so
EOF
fi

git add .
git commit -m "init commit" -q

if [ "$1" == true ]; then
  cd ..
  git submodule add ./report/
fi
