{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    telegram-desktop
    qutebrowser
    mpv
    pureref
    zathura
    # vimiv-qt
  ];

}
