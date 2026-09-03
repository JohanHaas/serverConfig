{
  imports = [
    ../../common

    ./configuration.nix
    ./users.nix
    ./boot.nix
    ./ssh.nix
    ./networking.nix
    ./wireguard.nix
    ./docker.nix
    ./github-runner.nix
  ];
}
