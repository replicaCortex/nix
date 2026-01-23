{ pkgs, ... }:
let
  cli = with pkgs; [
    any-nix-shell
    bat
    broot
    btop
    ddgr
    direnv
    fd
    file
    fzf
    gallery-dl
    git
    imagemagick
    jq
    just
    lsd
    neovim
    nh
    pandoc
    qwen-code
    rip2
    ripgrep
    sqlite
    taskwarrior-tui
    taskwarrior3
    wl-clipboard
    xcp
    yt-dlp
    zk
  ];

  gui = with pkgs; [
    xdg-desktop-portal-termfilechooser
    xwayland-satellite
    cliphist
    gammastep
    gimp
    krita
    beeref
    pkgs.zen-browser.default
    qbittorrent-enhanced
    telegram-desktop
  ];

  media = with pkgs; [
    chafa
    ffmpeg
    mpv
    vimiv-qt
    zathura
  ];

  fmt = with pkgs; [
    prettier
    shfmt
    stylua
    taplo
  ];

  lsp = with pkgs; [
    bash-language-server
    fish-lsp
    inotify-tools
    just-lsp
    lua-language-server
    nil
  ];

  compress = with pkgs; [
    gnutar
    gzip
    unrar
    unzip
    zstd
  ];
in
{
  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = media ++ cli ++ gui ++ fmt ++ lsp ++ compress;
  };
}
