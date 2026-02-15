{
  # virtualisation.podman.enable = true;
  virtualisation.docker.enable = true;

  users.users.replica = {
    extraGroups = [ "docker" ];
  };
}
