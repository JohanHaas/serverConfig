{
  config,
  pkgs,
  ...
}:
{


  networking.nat.enable = true;
  networking.nat.externalInterface = "enp1s0";
  networking.nat.internalInterfaces = [ "wg0" ];
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.firewall.trustedInterfaces = [ "wg0" ];

  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.100.0.1/24" ];
    listenPort = 51820;

    privateKeyFile = "/var/lib/wireguard/privatekey";

    peers = [
      { #homeserver
        publicKey = "eTHjEb3pPDvUXsSBW3Guz8kVGfW5mqqfII8UFCdDiC4=";
        allowedIPs = [ "10.100.0.2/32" ];
      }
      { #laptop
        publicKey = "o3Tl8dBH124bvBrhciExeAgIedM0wLuqsDKWCRA9IW0=";
        allowedIPs = [ "10.100.0.3/32" ];
      }
    ];
  };
}
