{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # xp-pen-deco-01-v2-driver
    # p7zip
    git

    nh
    ripgrep
    wl-clipboard
    cliphist
    bat

    fzf

    gnutar
    gzip
    unzip

    ffmpeg-full
    vimiv-qt
    (callPackage ../zen/zen.nix {})

    xdragon

    file

    telegram-desktop
    python312
    tree-sitter

    gcc
    swaycwd

    zk
    neovim
    mpv
    zathura
    texlive.combined.scheme-full

    grim
    slurp

    # lsp
    basedpyright
    black

    prettier

    alejandra

    stylua
    lua-language-server

    bash-language-server
    shfmt

    texlab
  ];
}
