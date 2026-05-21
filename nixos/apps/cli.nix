{ pkgs, pkgs-neovim, ... }:
{
  environment.systemPackages = with pkgs; [
    distrobox

    aria2
    bat
    batsignal
    broot
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
    lsix
    pkgs-neovim.neovim
    nh
    nil
    nixfmt
    rip2
    ripgrep
    sqlite
    unzip
    zip
    zstd

    # wine
    xwayland-satellite

    xdg-desktop-portal-termfilechooser
  ];
}
