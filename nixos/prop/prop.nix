{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    home-manager
    xp-pen-deco-01-v2-driver
    pureref
    # vagrant
    p7zip
    p7zip-rar
    # osu-lazer
  ];
}
