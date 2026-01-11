{pkgs, ...}: let
  cli = with pkgs; [
    # xwayland-satellite
    any-nix-shell
    bat
    broot
    btop
    ddgr
    delta
    direnv
    # dragon-drop
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
    nix-direnv
    pandoc
    qwen-code
    rip2
    ripgrep
    sqlite
    taskwarrior-tui
    taskwarrior3
    wl-clipboard
    wtype
    xcp
    yt-dlp
    zk
  ];

  other = with pkgs; [
    # aseprite
    xdg-desktop-portal-termfilechooser
    # xwayland-satellite
    # blender
    cliphist
    gammastep
    # gimp
    pkgs.zen-browser.default
    qbittorrent-enhanced
    telegram-desktop
  ];

  media = with pkgs; [
    chafa
    ffmpeg-full
    mpv
    vimiv-qt
    zathura
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
    just-lsp
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
    zstd
  ];
in {
  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = media ++ cli ++ other ++ fmt ++ lsp ++ compress;
  };
}
