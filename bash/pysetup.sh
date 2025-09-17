if [ ! -f shell.nix ]; then
  cat >>shell.nix <<EOF
{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell rec {
  buildInputs = with pkgs; [
    python312Packages.uv
  ];

  shellHook = ''
    export LD_LIBRARY_PATH="\${pkgs.zlib}/lib:\$LD_LIBRARY_PATH"
    export LD_LIBRARY_PATH="\${pkgs.stdenv.cc.cc.lib.outPath}/lib:\$LD_LIBRARY_PATH"

    export UV_VENV_CLEAR=1

    uv venv
    source .venv/bin/activate
    uv pip install -r requirements.txt
    uv pip freeze >| requirements.txt

    trap 'rm -rf .venv' EXIT
  '';
}
EOF
fi

mkdir src
touch requirements.txt
