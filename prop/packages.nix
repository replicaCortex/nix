{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # xp-pen-deco-01-v2-driver
    git

    nh
    wl-clipboard
    cliphist
    bat

    fzf
    ripgrep
    fd

    gnutar
    gzip
    unzip
    p7zip

    ffmpeg-full
    vimiv-qt
    (callPackage ../zen/zen.nix {})

    xdragon

    file
    btop

    telegram-desktop
    python312
    luajit

    gcc
    swaycwd

    zk
    neovim

    mpv

    zathura
    qbittorrent-enhanced
    texlive.combined.scheme-full

    grim
    slurp

    # lsp
    basedpyright
    # ty
    black

    prettier

    alejandra

    stylua
    lua-language-server

    bash-language-server
    shfmt

    tree-sitter

    texlab
  ];
}
