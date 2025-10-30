{
  config,
  lib,
  pkgs,
  ...
}: let
  dir = builtins.dirOf __curPos.file;
in {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nix-netcup";

  time.timeZone = "Europe/Amsterdam";

  services.xserver.xkb.layout = "de";

  users.users.nixer = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = with pkgs; [
      tree
    ];

    hashedPassword = "$y$j9T$zpBx1gFC6rnIaO0h1Z/.2.$WLT53HkIDSKTxQrbcr1Af135OPz/q3oCC1ee2TVkvf0";

    openssh.authorizedKeys.keys = [
      (builtins.readFile ./rs-server.pub)
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  services.openssh = {
    enable = true;
    #authorizedKeysFiles = [
    #  "${dir}/rs-server.pub"
    #];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = ["nixer"];
    };
  };

  nix.settings.trusted-users = ["nixer"];

  networking.firewall.allowedTCPPorts = [];
  networking.firewall.allowedUDPPorts = [];

  system.stateVersion = "25.05";
}
