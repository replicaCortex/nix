{ pkgs, ... }:
{
  imports = [
    # ./podman.nix
    ./packages.nix
    ./niri/niri.nix
    ./bluetooth.nix
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fonts = {
    fontconfig = {
      antialias = false;
    };
    packages = with pkgs; [
      nerd-fonts.ubuntu
      ubuntu_font_family
    ];
  };

  # services.zapret = {
  #   enable = true;
  #   params = [
  #     "--dpi-desync=fake,disorder2"
  #     "--dpi-desync-ttl=1"
  #     "--dpi-desync-autottl=2"
  #   ];
  # };

  services.auto-cpufreq.enable = true;

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
    LC_TIME = "en_US.UTF-8";
  };

  users.users.replica = {
    isNormalUser = true;
    description = "replica";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  services.getty.autologinUser = "replica";

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  services.displayManager.ly.enable = true;

  # services.openssh.enable = true;
  system.stateVersion = "24.11";
}
