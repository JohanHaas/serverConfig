{
  config,
  pkgs,
  ...
}: {
  networking.hostName = "nix-netcup";

  networking.firewall.allowedTCPPorts = [];
  networking.firewall.allowedUDPPorts = [];
  networking.firewall.enable = true;

  services.fail2ban.enable = true;
}
