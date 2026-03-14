{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    # wayland
    waybar
    brightnessctl
    dunst
    # swaybg
    swww
    foot
  ];
}
