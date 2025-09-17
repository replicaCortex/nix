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
  ];

  shellHook =
    if mode != "preview"
    then ''
      alias m="quarto render index.qmd"
      alias z="zen http://localhost:8080"
      alias za="zathura **/*.pdf"
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

book:
  chapters:
    - index.qmd

format:
  # docx:
  #   reference-doc: template.docx
  #   toc: false
  html:
    number-chapters: false
    toc: false
    css: jupyter.css
    theme:
      dark: darkly
  pdf:
    pdf-engine: lualatex
    mainfont: "Ubuntu"
    monofont: "Ubuntu mono"
    sansfont: "Ubuntu"
    toc: false
lang: ru
EOF
fi

if [ ! -f jupyter.css ]; then
  cat >>jupyter.css <<EOF
execute:
  echo: false

project:
  type: book

jupyter: quarto

book:
  chapters:
    - index.qmd

format:
  # docx:
  #   reference-doc: template.docx
  #   toc: false
  html:
    number-chapters: false
    toc: false
    css: jupyter.css
  pdf:
    pdf-engine: lualatex
    mainfont: "Ubuntu"
    monofont: "Ubuntu mono"
    sansfont: "Ubuntu"
    toc: false
lang: ru
EOF
fi

echo "ipykernel" >requirements.txt

touch index.qmd
mkdir resources
mkdir src
cp ~/nix/**/template.docx .
