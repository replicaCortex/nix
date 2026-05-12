{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  services.displayManager.ly.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    waybar
    brightnessctl
    gammastep
    dunst
    swaybg
    foot
    wl-clipboard
    cliphist

    hyprshot
  ];
}
