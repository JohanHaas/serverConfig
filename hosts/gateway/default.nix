{
  imports = [
    ../../common

    ./configuration.nix
    ./users.nix
    ./boot.nix
    ./ssh.nix
    ./networking.nix
    ./docker.nix
    ./github-runner.nix
    ./vaultwarden.nix
  ];
}
