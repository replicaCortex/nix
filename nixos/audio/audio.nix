{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alsa-utils
  ];

  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.enable = false;
  hardware.alsa.enablePersistence = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
