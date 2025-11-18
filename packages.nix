{ pkgs, ... }:
let
  cli = with pkgs; [
    any-nix-shell
    bat
    btop
    direnv
    dragon-drop
    fd
    ffmpeg-full
    file
    fzf
    git
    jq
    lsd
    neovim
    nh
    nix-direnv
    pandoc
    qwen-code
    ripgrep
    taskwarrior-tui
    taskwarrior3
    wl-clipboard
    zk
  ];

  other = with pkgs; [
    aseprite
    # xwayland-satellite
    cliphist
    gammastep
    pkgs.zen-browser.default
    qbittorrent-enhanced
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
    (pkgs.python312.withPackages (ps: [
      ps.mdformat
      ps.mdformat-frontmatter
    ]))
    alejandra
    fixjson
    mbake
    prettier
    shfmt
    sleek
    stylua
    taplo
  ];

  lsp = with pkgs; [
    bash-language-server
    fish-lsp
    inotify-tools
    lua-language-server
    nil
    sqls
    yaml-language-server
  ];

  compress = with pkgs; [
    gnutar
    gzip
    p7zip
    unrar
    unzip
  ];
in
{
  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = media ++ cli ++ other ++ fmt ++ lsp ++ compress;
  };
}
