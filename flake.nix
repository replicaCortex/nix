{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    # catppuccin.url = "github:catppuccin/nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur-renesat = {
      url = "github:renesat/nur-renesat";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixpkgs-stable,
    nixvim,
    # catppuccin,
    self,
    nur-renesat,
    ...
  }: {
    nixosConfigurations.nixos = nixpkgs-stable.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./nixos/configuration.nix
      ];
    };

    homeConfigurations.replica = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      extraSpecialArgs = {
        inherit self;
        euporiePkg = nur-renesat.packages.x86_64-linux.euporie;
      };

      modules = [
        nixvim.homeManagerModules.nixvim
        # catppuccin.homeModules.catppuccin

        ./home-manager/home.nix
      ];
    };
  };
}
