{ pkgs, ... }:
{
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;
  # services.flatpak.enable = true;

  # virtualisation.waydroid.enable = true;

  environment.systemPackages = with pkgs; [
    docker-compose
    # waydroid
  ];
}
