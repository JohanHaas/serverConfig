{ config, pkgs, ... }:
{
  virtualisation.podman.enable = true;
  virtualisation.oci-containers.backend = "podman";

  systemd.tmpfiles.rules = [
    "d /storage/cloud-data 0755 root root -"
    "d /storage/filebrowser 0755 root root -"
  ];

  virtualisation.oci-containers.containers."filebrowser" = {
    image = "filebrowser/filebrowser:latest";
    ports = [ "8081:80" ];
    volumes = [
      "/storage/filebrowser/filebrowser.db:/database/filebrowser.db:Z"
      "/storage/filebrowser/settings.json:/config/settings.json:Z"
      "/storage/cloud-data:/srv:Z"
    ];

    cmd = [ 
      "--database" "/database/filebrowser.db" 
      "--config" "/config/settings.json"
      "--address" "0.0.0.0"  
      "--port" "80"
    ];

    user = "0:0";
  };

  networking.firewall.allowedTCPPorts = [ 8081 ];
}
