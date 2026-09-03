{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nbfc-linux
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 0;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelModules = [ "coretemp" "nct6775" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nix-home-server";
  zramSwap.enable = true;

  boot.swraid.mdadmConf = ''
    MAILADDR Johanhaas99@gmail.com
  '';

  system.stateVersion = "25.05";
}
