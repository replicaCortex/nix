PROJECT_NAME="$(basename "${PWD}")"

nix-shell -p cargo --run "cargo init"

if [ ! -f shell.nix ]; then
  cat >>shell.nix <<EOF
{
  pkgs ? import <nixpkgs> { },
}:
let
  rust = with pkgs; [
    cargo
    rustc
    rustfmt
    clippy
    gdb
    rust-analyzer
  ];

  utils = with pkgs; [
    just
    just-lsp
  ];
in
pkgs.mkShell {
  buildInputs = rust ++ utils;
}
EOF
fi

if [ ! -f justfile ]; then
  cat >>justfile <<EOF
default:
    @just --list

build:
    cargo build 

test:
    cargo test

run:
    cargo run 

clippy:
    cargo-clippy

debug:
    rust-gdb -tui ./target/debug/$PROJECT_NAME
EOF
fi

if [ ! -f .envrc ]; then
  cat >>.envrc <<EOF
use nix 
EOF

  direnv allow
fi

# --- git ---

git branch -m main
git add .
git commit -m "init commit"
