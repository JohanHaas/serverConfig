{
  config,
  pkgs,
  ...
}: {
  networking.hostName = "nix-netcup";

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22];
    allowedUDPPorts = [];
    checkReversePath = true;
    trustedInterfaces = ["lo"];
  };

  services.fail2ban.enable = true;
}
