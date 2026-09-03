{ ... }:
{
  # Reachable from internet, not only wg0. Key-only auth prevents brute force.
  # Removes single point of failure on wg0 during reconfiguration.
  networking.firewall.allowedTCPPorts = [ 22 ];
}
