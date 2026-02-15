{ pkgs, ... }:
{
  imports = [
    ./gui/media_editors.nix
    ./gui/gesture-drawing.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      pkgs.zen-browser.default
      qbittorrent-enhanced
      telegram-desktop
      xdg-desktop-portal-termfilechooser
      xwayland-satellite
    ];
  };
}
