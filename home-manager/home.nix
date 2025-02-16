{
  imports = [
    ./modules/bundle.nix
    ./catppuccin.nix

    # ./modules/Rust/index.nix
  ];

  home = {
    username = "replica";
    homeDirectory = "/home/replica";
    stateVersion = "24.11";
  };
}
