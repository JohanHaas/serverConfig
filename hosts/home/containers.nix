{
  config,
  pkgs,
  ...
}:
{
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune.enable = true;
      liveRestore = false;
    };
  };

  virtualisation.oci-containers.backend = "docker";
  
  virtualisation.oci-containers.containers = {
    "nextcloud-aio-mastercontainer" = {
      image = "nextcloud/all-in-one:latest";
      ports = [
        "8080:8080"
        "8443:8443"
        "11000:11000"
      ];
      volumes = [
        "nextcloud_aio_mastercontainer:/mnt/docker-aio-config"
        "/run/docker.sock:/var/run/docker.sock:ro"
      ];
      environment = {
        "NEXTCLOUD_DATADIR" = "/mnt/nextcloud-data";
        "SKIP_DOMAIN_CHECK" = "true";
        "UPSTREAM_EDITS" = "true";
        "NEXTCLOUD_TRUSTED_DOMAINS" = "cloud.local 10.100.0.2";
        "NEXTCLOUD_DOMAIN" = "cloud.local";
      };
      extraOptions = [
        "--privileged"
        "--init"
      ];
    };
  };
  
  networking.firewall.allowedTCPPorts = [ 8080 8443 11000 ];
}

