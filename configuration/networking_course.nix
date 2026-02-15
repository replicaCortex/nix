{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      ciscoPacketTracer9
      wireshark
    ];
  };

  programs.wireshark.enable = true;

  users.users.replica = {
    extraGroups = [ "wireshark" ];
  };
}
