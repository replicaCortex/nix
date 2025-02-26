{
  config,
  pkgs,
  lib,
  ...
}: let
  fuck = ''$'';
in {
  imports = [
    ./zsh/zsh.nix
    # TODO: Замена на qemu
    ./vbox/vbox.nix
    ./audio/audio.nix
    # ./portal/portal.nix
    ./nvidia/nvidia.nix
    # ./overlay/overlay.nix
    ./syncthing/syncthing.nix
    ./bluetooth/bluetooth.nix
    ./filesystem/filesystem.nix
    ./hardware-configuration/hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  fonts = {
    fontconfig = {
      antialias = false;
    };
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us,ru";
  };

  users.users.replica = {
    isNormalUser = true;
    description = "replica";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [];
  };

  services.getty.autologinUser = "replica";

  environment.systemPackages = with pkgs; [
    home-manager
    # osu-lazer
  ];

  services.xserver = {
    enable = true;
    windowManager.bspwm.enable = true;
    displayManager.lightdm = {
      enable = true;
      # background = ../home-manager/modules/conf/background/nixos-wallpaper-catppuccin-mocha.png;
      greeters.slick.enable = true;
    };
    desktopManager.xterm.enable = false;

    # https://github.com/dustinlyons/nixos-config/tree/main
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };
  };

  services.openssh.enable = true;
  system.stateVersion = "24.11";
}
