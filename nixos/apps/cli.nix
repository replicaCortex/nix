{ pkgs, pkgs-neovim, ... }:
{
  environment.systemPackages = with pkgs; [
    distrobox

    aria2
    bat
    batsignal
    btop
    ddgr
    eza
    fd
    file
    fzf
    gitMinimal
    jq
    jujutsu
    just
    libnotify
    mupdf
    nh
    nil
    moreutils
    nixfmt
    pandoc
    pkgs-neovim.neovim
    rip2
    ripgrep
    sqlite
    timg
    # tree-sitter-cli
    unzip
    zip
    zstd

    # wine
    xwayland-satellite

    xdg-desktop-portal-termfilechooser
  ];
}
