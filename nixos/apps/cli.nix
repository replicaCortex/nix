{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    distrobox

    gitMinimal
    btop
    lsd
    zstd
    unzip
    file
    nh
    ddgr
    broot
    fzf
    jq
    just
    sqlite
    neovim
    bat
    fd
    ripgrep
    rip2

    wine
    xwayland-satellite

    xdg-desktop-portal-termfilechooser
  ];
}
