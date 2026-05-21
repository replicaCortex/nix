{
  description = "Bt-bt-bt";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    neovim.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      nixpkgs,
      neovim,
      ...
    }:
    let
      system = "x86_64-linux";

      pkgs-neovim = import neovim {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit pkgs-neovim;
        };

        modules = [
          ./configuration.nix
        ];
      };
    };
}
