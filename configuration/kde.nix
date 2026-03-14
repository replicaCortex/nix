{ pkgs, ... }:

{
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    gwenview
    okular
    kate
    khelpcenter
    krdc

    kmahjongg
    kmines
    konversation
    kpat
    ksudoku
    ktorrent
    akonadi
  ];

  users.users.artist = {
    isNormalUser = true;
    description = "Digital Art Station";
    extraGroups = [
      "networkmanager"
      "video"
      "input"
    ];
    initialPassword = "foo";

    packages = with pkgs; [
      krita
      gimp
      beeref
      (pkgs.callPackage ./packages/gui/gesture-drawing/default.nix { })
    ];
  };

}
