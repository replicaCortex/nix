{ pkgs, ... }:
{
  users.users.replica = {
    isNormalUser = true;
    shell = pkgs.bash;
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "kvm"
    ];
  };
  services.getty.autologinUser = "replica";
}
