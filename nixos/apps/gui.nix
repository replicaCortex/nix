{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    telegram-desktop
    qutebrowser
    mpv
    zathura
    # vimiv-qt
  ];

  # programs.steam.enable = true;
}
