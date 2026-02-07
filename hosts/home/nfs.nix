{
  config,
  pkgs,
  ...
}:
{
  services.nfs.server = {
    enable = true;
    exports = ''
      #homenetwork
      /storage 192.168.178.0/24(rw,sync,no_subtree_check,all_squash,anonuid=1000,anongid=100)
      #laptop over wireguard
      /storage 10.100.0.3(rw,sync,no_subtree_check,all_squash,anonuid=1000,anongid=100)
    '';
  };
  networking.firewall = {
    allowedTCPPorts = [ 111  2049 4000 4001 4002 20048 ];
    allowedUDPPorts = [ 111 2049 4000 4001  4002 20048 ];
  };
}
