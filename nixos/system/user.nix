{ pkgs, ... }:
{
  users.users.replica = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
      "kvm"
    ];
  };
  programs.fish.enable = true;
  services.getty.autologinUser = "replica";
}
