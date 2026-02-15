{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      chafa
      ffmpeg
      mpv
      vimiv-qt
      zathura
    ];
  };
}
