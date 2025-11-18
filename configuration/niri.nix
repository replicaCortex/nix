{ pkgs, ... }:
{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    waybar
    brightnessctl
    dunst
    # swaybg
    swww
    foot
  ];
}
