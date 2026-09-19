{ ... }:
{
  # Reachable from internet, not only the tailnet. Key-only auth prevents brute
  # force. Headscale runs on this host, so SSH must not depend on the tailnet.
  networking.firewall.allowedTCPPorts = [ 22 ];
}
