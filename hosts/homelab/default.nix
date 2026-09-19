{
  imports = [
    ../../common

    ./configuration.nix
    ./wireguard.nix
    ./users.nix
    ./ssh.nix
    ./fail2ban.nix
    ./silence.nix
    ./raid-notify.nix
    ./smartd.nix
    # Deaktiviert: /storage wandert nach Nextcloud. Bis dahin bleibt nfs.nix
    # liegen, falls doch noch ein Share gebraucht wird.
    # ./nfs.nix
    ./containers.nix
    ./github-runner.nix
  ];
}
