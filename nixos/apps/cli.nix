{ pkgs, ... }:
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
    just
    libnotify
    lsix
    neovim
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
