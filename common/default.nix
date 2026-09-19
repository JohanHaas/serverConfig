{
  imports = [
    ./locale.nix
    ./nix.nix
    ./packages.nix
    ./ssh.nix
    ./fail2ban.nix
    ./firewall.nix
    ./tailscale.nix
    ./github-runner.nix
    ./sops.nix
    ./alerting.nix
    ./mail.nix
  ];
}
