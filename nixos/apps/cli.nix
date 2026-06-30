{ pkgs, pkgs-neovim, ... }:

{
  programs.kdeconnect.enable = true;
  programs.weylus = {
    enable = true;
    users = [ "replica" ];
    openFirewall = true;
  };
  hardware.uinput.enable = true;

  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-gtk
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
    shfmt
    stylua
    slurp
    sqlite
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
