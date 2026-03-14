{ pkgs, ... }:
{
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;

  # virtualisation.waydroid.enable = true;

  environment.systemPackages = with pkgs; [
    docker-compose
    # waydroid
  ];
}
