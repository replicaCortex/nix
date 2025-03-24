{
  imports = [
    ./modules/bundle.nix
    ./catppuccin.nix
  ];

  home = {
    username = "replica";
    homeDirectory = "/home/replica";
    stateVersion = "24.11";
  };
}
