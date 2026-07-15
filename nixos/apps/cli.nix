{ pkgs, pkgs-neovim, ... }:

{
  programs.kdeconnect.enable = true;
  programs.weylus = {
    enable = true;
    openFirewall = true;
    users = [ "replica" ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ "gtk" ];
      };
      niri = {
        "org.freedesktop.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.portal.Screenshot" = [ "gnome" ];
      };
    };
  };
  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    android-tools
    aria2
    bat
    batsignal
    btop
    ddgr
    deno
    eza
    fd
    ffmpeg
    ffmpegthumbnailer
    file
    fzf
    gcc
    gdscript-formatter
    gitMinimal
    imagemagick
    imv
    jq
    jujutsu
    just
    just-lsp
    libnotify
    lua-language-server
    mupdf
    nh
    nil
    nixfmt
    nodejs
    nsxiv
    pandoc
    pkgs-neovim.neovim
    prettier
    rar
    repomix
    rip2
    ripgrep
    scrcpy
    shfmt
    slurp
    sqlite
    stylua
    timg
    tmsu
    tree-sitter
    unzip
    uv
    wf-recorder
    zip
    zk
    zstd

    # wine
    xwayland-satellite

    xdg-desktop-portal-termfilechooser
  ];
}
