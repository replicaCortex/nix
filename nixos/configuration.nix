{
  imports = [
    ./hardware-configuration.nix

    # System core
    ./system/boot.nix
    ./system/create-config.nix
    ./system/locale.nix
    ./system/network.nix
    ./system/user.nix

    # Hardware
    ./hardware/bluetooth.nix
    ./hardware/graphics.nix
    # ./hardware/zapret.nix
    ./hardware/v2raya.nix

    # Desktop Environment
    ./desktop/niri.nix
    # ./desktop/hyprland.nix
    ./desktop/fonts.nix

    # Host Applications
    ./apps/cli.nix
    ./apps/gui.nix
    ./apps/containers.nix
  ];

  system.stateVersion = "24.11";
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;
}
