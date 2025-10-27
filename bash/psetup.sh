set -e

if [ ! -f shell.nix ]; then
  cat >>shell.nix <<EOF
{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    python312Packages.uv

    ty
    ruff
  ];

  shellHook = ''
    export LD_LIBRARY_PATH="\${pkgs.zlib}/lib:\$LD_LIBRARY_PATH"
    export LD_LIBRARY_PATH="\${pkgs.stdenv.cc.cc.lib.outPath}/lib:\$LD_LIBRARY_PATH"

    export UV_VENV_CLEAR=1

    uv venv
    source .venv/bin/activate
    uv pip compile pyproject.toml --extra dev -o requirements.lock
    uv pip sync requirements.lock
  '';
}
EOF
fi

mkdir src

pyproject_path=$(find "$HOME/nix/" -name "pyproject.toml" -type f)
cp "$pyproject_path" .

docs_path=$(find "$HOME/nix/" -name "pydocs" -type d)
cp -r "$docs_path" .
mv "pydocs" "docs"

# --- git ---

git init -q
git branch -m main -q

if [ ! -f .gitignore ]; then
  cat >>.gitignore <<EOF
.venv
EOF
fi

git add .
git commit -m "init commit" -q

# --- quarto ---

read -rp "quarto?(y/n): " quarto

if [ -n "$quarto" ]; then
  submodel=true
fi

if [ "${quarto,,}" == "y" ] || [ "${quarto,,}" == "yes" ]; then
  mkdir -p report
  cd report || exit

  qsetup_path=$(find "$HOME/nix" -name "qsetup.sh" -type f | head -n 1)
  "$qsetup_path" "$submodel"
fi
