{
  imports = [
    ./settings/font.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  programs.steam = {
    enable = true;
  };

  # hardware.opentabletdriver.enable = true;
  nixpkgs.config.allowUnfree = true;

  programs.niri.enable = true;
  # services.displayManager.gdm.enable = true;
  services.displayManager.ly.enable = true;
  programs.fish.enable = true;

  # services.zapret = {
  #   enable = true;
  #   params = [
  #     "--dpi-desync=fake,disorder2"
  #     # "--dpi-desync-ttl=1"
  #     "--dpi-desync-autottl=2"
  #     "--dpi-desync-fooling=md5sig,badsum"
  #     "--dpi-desync-split-pos=1"
  #     "--dpi-desync-repeats=6"
  #   ];
  # };

  # services.auto-cpufreq.enable = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
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

  system.stateVersion = "24.11";

  systemd.services.disable-turbo-boost = {
    wantedBy = [ "multi-user.target" ];
    script = ''
      echo 0 > /sys/devices/system/cpu/cpufreq/boost || true
    '';
  };
}
