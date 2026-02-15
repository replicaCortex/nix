{
  imports = [
    ./packages/cli.nix
    ./packages/compress.nix
    ./packages/fmt.nix
    ./packages/game.nix
    ./packages/gui.nix
    ./packages/lang.nix
    ./packages/lsp.nix
    ./packages/media.nix
  ];

  nixpkgs.config.allowUnfree = true;
}
