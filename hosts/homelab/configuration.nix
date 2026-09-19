{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nbfc-linux
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 0;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.cpu.intel.updateMicrocode = true;

  boot.kernelModules = [ "coretemp" "nct6775" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nix-home-server";
  zramSwap.enable = true;

  system.stateVersion = "25.05";
}
