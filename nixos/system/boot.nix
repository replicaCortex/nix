{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  systemd.services.disable-turbo-boost = {
    wantedBy = [ "multi-user.target" ];
    script = "echo 0 > /sys/devices/system/cpu/cpufreq/boost || true";
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "userspace";
    cpufreq = {
      min = 1400000;
      max = 1400000;
    };
  };
}
