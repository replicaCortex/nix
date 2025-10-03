PROJECT_NAME="$(basename "${PWD}")"

nix-shell -p cargo --run "cargo init"

if [ ! -f shell.nix ]; then
  cat >>shell.nix <<EOF
{
  pkgs ? import <nixpkgs> { },
  mode ? "dev",
}:
let
  rust = with pkgs; [
    cargo
    rustc

    rustfmt
    clippy

    gdb
  ];

  multiplex = with pkgs; [
    rust-analyzer
    ra-multiplex
    wayland
    pkg-config
  ];

  server_start = ''
    alias kr="pgrep 'ra-multiplex' | xargs kill"
    alias sr="ra-multiplex server & nvim --headless src/*.rs"
    sr
  '';

  aliases = ''
    alias cr="cargo run"
    alias cb="cargo build"
    alias ct="cargo test"
    alias cc="cargo-clippy"
    alias g="rust-gdb -tui ./target/debug/${PROJECT_NAME}"
  '';
in
pkgs.mkShell {
  buildInputs = if mode == "server" then rust ++ multiplex else rust;

  shellHook = if mode == "server" then server_start else aliases;
}
EOF
fi

# --- git ---

git branch -m main
git add .
git commit -m "init commit"

# --- quarto ---

read -rp "quarto?(y/n): " quarto

if [ -n "$quarto" ]; then
  submodel=true
fi

if [ "${quarto,,}" == "y" ] || [ "${quarto,,}" == "yes" ]; then
  mkdir -p report
  cd report || exit

  QSETUP_PATH=$(find "$HOME/nix" -name "qsetup.sh" -type f | head -n 1)
  "$QSETUP_PATH" "$submodel"
fi
