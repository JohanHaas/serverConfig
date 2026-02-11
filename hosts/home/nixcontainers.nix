{ config, pkgs, ... }:

{
  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-nextcloud" ];
    externalInterface = "enp1s0"; 
  };

  containers."nextcloud" = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.233.1.1";
    localAddress = "10.233.1.2";

    config = { config, pkgs, lib, ... }: {
      services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud32; 
        hostName = "10.100.0.2";    

        config = {
          adminpassFile = "/etc/nextcloud-admin-pass";
          dbtype = "pgsql";
          adminuser = "admin";
        };

        settings = {
          trusted_domains = [ "10.100.0.2" "10.233.1.2" "192.168.178.181" ];
          overwriteProtocol = "http";
        };
      };

      services.postgresql = {
        enable = true;
        ensureDatabases = [ "nextcloud" ];
        ensureUsers = [{
          name = "nextcloud";
          ensureDBOwnership = true;
        }];
      };

      networking.firewall.allowedTCPPorts = [ 80 ];
      system.stateVersion = "24.05";
    };
  };

  networking.nat.forwardPorts = [
    {
      sourcePort = 80;
      proto = "tcp";
      destination = "10.233.1.2:80";
    }
  ];

  networking.firewall.allowedTCPPorts = [ 80 ];
}
