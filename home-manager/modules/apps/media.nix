{pkgs, ...}: {
  programs.feh = {
    enable = true;
    #themes.feh = ["--image-bg"];
  };

  programs.zathura = {
    enable = true;
  };

  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [modernx-zydezu thumbfast autosubsync-mpv];
    config = {
      profile = "gpu-hq";
      # ytdl-format = "bestvideo+bestaudio";
      cache = "yes";
      ytdl = "yes";
      script-opts = "ytdl_hook-try_ytdl_first=yes";
      audio-device = "pulse";
      af = "lavfi=[dynaudnorm]";
    };
  };

  # programs.obs-studio = {
  #   enable = true;
  # };

  home.packages = with pkgs; [escrotum];
}
