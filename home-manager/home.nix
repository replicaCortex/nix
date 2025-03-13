{
  imports = [
    ./modules/bundle.nix
    ./catppuccin.nix

    # ./modules/rust/norg-fmt.nix
  ];

  home = {
    username = "replica";
    homeDirectory = "/home/replica";
    stateVersion = "24.11";
  };
}
