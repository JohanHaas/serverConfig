{ lib, ... }:
{
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;

  networking.interfaces.enp1s0.ipv6.addresses = [{
    address = "2a01:4f8:c0c:a6d2::1";
    prefixLength = 64;
  }];

  networking.defaultGateway6 = {
    address = "fe80::1";
    interface = "enp1s0";
  };

  # Sonst maskiert Tailscale Verkehr vom Tailnet an Docker-Container auf die
  # Bridge-IP, und Caddys remote_ip-Filter (Tailnet-only) sperrt alle aus. Ob
  # das greift, haengt nur davon ab, ob ts-forward vor den Docker-Regeln
  # landet. Der Gateway routet keine Subnetze, braucht das SNAT also nicht.
  services.tailscale.extraSetFlags = [ "--snat-subnet-routes=false" ];
}
