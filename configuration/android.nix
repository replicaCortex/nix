{ pkgs, ... }:
{
  users.users.replica.extraGroups = [ "kvm" ];
  environment.gnome.excludePackages = with pkgs; [
    android-studio
  ];
}
