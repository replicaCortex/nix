{
  description = "Bt-bt-bt";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nix-search = {
    #   url = "github:diamondburned/nix-search";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = {
    self,
    nixpkgs,
    zen-browser,
    # nix-search,
    ...
  } @ inputs: let
    zen-overlay = final: prev: {
      zen-browser = inputs.zen-browser.packages.${prev.system};
    };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        {
          nixpkgs.overlays = [
            zen-overlay
            # nix-search
          ];
        }
        ./configuration/configuration.nix
      ];
    };
  };
}
