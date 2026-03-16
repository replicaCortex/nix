{ pkgs, ... }:
{
  programs.niri.enable = true;
  services.displayManager.ly.enable = true;

  environment.systemPackages = with pkgs; [
    waybar
    brightnessctl
    gammastep
    dunst
    swaybg
    foot
    wl-clipboard
    cliphist
  ];
}
