{
  config,
  pkgs,
  ...
}:
{
  networking.firewall.trustedInterfaces = [ "wg0" ];
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.2/24" ];
      privateKeyFile = "/var/lib/wireguard/privatekey";

      peers = [
        {
          publicKey = "YIBQ3p8oSzBWCDtF2pxqDYtlKgO14HYb0HkXz2+soDU=";
          allowedIPs = [ "10.100.0.0/24" ];

          endpoint = "159.69.23.42:51820";
          persistentKeepalive = 25;
        }
      ];
    };

    proton = let
      namespace = "proton";
    in
    {
      ips = [ "10.2.0.2/32" ];
      privateKeyFile = "/var/lib/wireguard/proton-privatekey";

      interfaceNamespace = namespace;

      preSetup = ''
        ${pkgs.iproute2}/bin/ip netns add ${namespace} || true
        ${pkgs.iproute2}/bin/ip netns exec ${namespace} ${pkgs.iproute2}/bin/ip link set lo up
      '';

      postShutdown = ''
        ${pkgs.iproute2}/bin/ip netns del ${namespace} || true
      '';

      peers = [
        {
          publicKey = "F/2MSsC7RsfHojjhonhgo40IRmyP3YEYsjoBQW+dwyY=";
          allowedIPs = [ "0.0.0.0/0" "::/0" ];

          endpoint = "146.70.156.2:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  environment.etc."netns/proton/resolv.conf".text = "nameserver 10.2.0.1\n";
}
