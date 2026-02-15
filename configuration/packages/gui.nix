{ pkgs, ... }:
{
  imports = [
    ./gui/media_editors.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      pkgs.zen-browser.default
      qbittorrent-enhanced
      telegram-desktop
      xdg-desktop-portal-termfilechooser
      xwayland-satellite
      (pkgs.callPackage ./gui/gesture-drawing/default.nix { })
    ];
  };
}
