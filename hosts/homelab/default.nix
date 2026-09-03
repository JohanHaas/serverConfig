{
  imports = [
    ../../common

    ./configuration.nix
    ./wireguard.nix
    ./users.nix
    ./ssh.nix
    ./fail2ban.nix
    ./silence.nix
    ./nfs.nix
    ./containers.nix
    ./github-runner.nix
  ];
}
