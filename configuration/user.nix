{ pkgs, ... }:
{
  users.users.replica = {
    isNormalUser = true;
    description = "replica";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
