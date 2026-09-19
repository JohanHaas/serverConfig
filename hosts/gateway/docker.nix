{
  config,
  pkgs,
  ...
}:
{
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    userland-proxy = false;
  };

  # Lets admin run docker compose without sudo. Note that membership in this
  # group is equivalent to root, since a container can bind-mount any path.
  users.users.admin.extraGroups = [ "docker" ];
}
