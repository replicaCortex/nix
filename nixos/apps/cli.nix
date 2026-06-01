{ pkgs, pkgs-neovim, ... }:
{
  environment.systemPackages = with pkgs; [
    distrobox

    aria2
    bat
    batsignal
    btop
    # chafa
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
    nh
    nil
    nixfmt
    pkgs-neovim.neovim
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
