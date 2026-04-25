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
    neovim
    nh
    rip2
    ripgrep
    sqlite
    # translate-shell
    unzip
    zip
    zstd
    nil
    nixfmt

    # wine
    xwayland-satellite

    xdg-desktop-portal-termfilechooser
  ];
}
