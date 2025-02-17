{
  programs.feh = {
    enable = true;
    #themes.feh = ["--image-bg"];
  };

  programs.zathura = {
    enable = true;
  };

  programs.mpv = {
    enable = true;
  };

  programs.obs-studio = {
    enable = true;
  };

  services.flameshot = {
    enable = true;

    settings = {
      General = {
        disabledTrayIcon = true;
        showStartupLaunchMessage = false;
      };
    };
  };
}
