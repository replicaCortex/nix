{pkgs, ...}: {
  nixpkgs.overlays = [
    (self: super: import ./term.nix self super)
  ];
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-termfilechooser
    ];
  };
}
