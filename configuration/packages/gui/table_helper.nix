{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      gnome-themes-extra
      adwaita-icon-theme
      pcmanfm
    ];
  };
}
