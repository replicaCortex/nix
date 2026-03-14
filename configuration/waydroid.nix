{ pkgs, ... }:
{
  virtualisation.waydroid.enable = true;

  users.users.replica = {
    extraGroups = [ "waydroid" ];
  };

  environment.systemPackages = with pkgs; [
    waydroid
    waydroid-helper
  ];

}
