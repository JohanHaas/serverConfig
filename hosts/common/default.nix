{
  config,
  pkgs,
  ...
}: {
  networking.firewall.enable = true;
  services.fail2ban.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
}
