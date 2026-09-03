{ ... }:
{
  # Hub for personal devices. Load-bearing configuration.
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
      { publicKey = "eTHjEb3pPDvUXsSBW3Guz8kVGfW5mqqfII8UFCdDiC4="; allowedIPs = [ "10.100.0.2/32" ]; }
      { publicKey = "o3Tl8dBH124bvBrhciExeAgIedM0wLuqsDKWCRA9IW0="; allowedIPs = [ "10.100.0.3/32" ]; }
      { publicKey = "raGtUM1V9fCxfKtCtbfUZhb8nHwgfb8JSrpC1ADiOnA="; allowedIPs = [ "10.100.0.4/32" ]; }
      { publicKey = "O/g/QrqJL746K4nWaCojVenJ4AKrIXc1VXHHmKg63Qw="; allowedIPs = [ "10.100.0.5/32"]; }
    ];
  };
}
