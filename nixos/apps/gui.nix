{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pkgs.zen-browser.default
    telegram-desktop
    mpv
    zathura
    vimiv-qt
  ];

  programs.steam.enable = true;
}
