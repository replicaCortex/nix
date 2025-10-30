{ pkgs, ... }:
let
  cli = with pkgs; [
    nh
    jq
    btop

    file
    git

    fzf
    fd
    ripgrep
    wl-clipboard

    zk
    taskwarrior3
    timewarrior
    taskwarrior-tui

    neovim

    ffmpeg-full

  ];

  other = with pkgs; [
    cliphist
    gammastep
    xdragon

    qbittorrent-enhanced

    pkgs.zen-browser.default
    telegram-desktop
  ];

  media = with pkgs; [
    chafa
    mpv
    vimiv-qt
    zathura
  ];

  virtual = with pkgs; [
    wineWowPackages.wayland
    qemu
  ];

  fmt = with pkgs; [
    prettier
    alejandra
    typstyle
    stylua
    shfmt
    mbake
    sleek
    taplo
    fixjson
    (pkgs.python312.withPackages (ps: [
      ps.mdformat
      ps.mdformat-frontmatter
    ]))
  ];

  lsp = with pkgs; [
    inotify-tools
    yaml-language-server
    lua-language-server
    bash-language-server
    nil
    sqls
  ];

  compress = with pkgs; [
    gnutar
    gzip
    unzip
    unrar
    p7zip
  ];
in
{
  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = media ++ cli ++ other ++ fmt ++ lsp ++ compress;
  };
}
