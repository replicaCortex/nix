function init_rust --description "init rust project"
    set -l PROJECT_NAME (basename "$PWD")

    nix-shell -p cargo --run "cargo init"

    if not test -f shell.nix
        echo "{
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
}" >shell.nix
    end

    if not test -f justfile
        echo "default:
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
    rust-gdb -tui ./target/debug/$PROJECT_NAME" >justfile
    end

    if not test -f .envrc
        echo "use nix" >.envrc
        direnv allow
    end

    if not test -d .git
        git init
    end

    git branch -m main
    git add .
    git commit -m "init commit"
end
