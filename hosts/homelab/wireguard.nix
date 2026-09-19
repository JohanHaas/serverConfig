{
  config,
  pkgs,
  ...
}:
{
  networking.wireguard.interfaces = {
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
