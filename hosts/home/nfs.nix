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
      /storage 192.168.1.0/24(rw,sync,no_subtree_check,all_squash,anonuid=1000,anongid=100)
      #laptop over wireguard
      /storage 10.100.0.3(rw,sync,no_subtree_check,all_squash,anonuid=1000,anongid=100)
    '';
  };
}
