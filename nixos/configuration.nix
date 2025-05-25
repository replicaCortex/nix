{pkgs, ...}: {
  imports = [
    ./vbox/vbox.nix
    ./xdg.mime/xdg.nix
    ./garbageCollection/autoGarbage.nix
    ./hardware-configuration/hardware-configuration.nix
    ./prop/prop.nix
    ./syncthing/syncthing.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # shell
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

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
  };

  environment.sessionVariables = {
    QT_QUICK_BACKEND = "vulkan";
  };

  services.getty.autologinUser = "replica";

  services.xserver = {
    enable = true;
    windowManager.bspwm.enable = true;

    displayManager.lightdm = {
      enable = true;
      background = ../static/wallpapers/pixel-galaxy.png;
    };

    desktopManager.xterm.enable = false;
    excludePackages = [pkgs.xterm pkgs.nano];

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
