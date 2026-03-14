{ pkgs, ... }:
{
  imports = [
    ./gui/media_editors.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      pkgs.zen-browser.default
      wine
      telegram-desktop
      # xdg-desktop-portal-termfilechooser
      # krita
      # gimp
      # beeref
      # gnomeExtensions.appindicator
      # gnomeExtensions.kando-integration
      # gnomeExtensions.color-picker
      # gnomeExtensions.unite
      # gruvbox-gtk-theme
      # gnomeExtensions.gjs-osk
      # evince
      # gruvbox-plus-icons
      # gnome-tweaks
      # gnome-shell-extensions
      # xwayland-satellite
      godotPackages_4_4.godot-mono
      (pkgs.callPackage ./gui/gesture-drawing/default.nix { })

      # nautilus
      # kando
      # loupe
      # xprop
      bleachbit
    ];
  };
}
