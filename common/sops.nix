{ sops-nix, host, ... }:
{
  imports = [ sops-nix.nixosModules.sops ];

  # Gemeinsame Secrets setzen stattdessen sopsFile = ../secrets/common.yaml.
  sops.defaultSopsFile = ../secrets + "/${host}.yaml";
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
}
