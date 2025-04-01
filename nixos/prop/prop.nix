{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    home-manager
    # postman
    xp-pen-deco-01-v2-driver
    pureref
    p7zip
    p7zip-rar
    # osu-lazer
  ];
}
