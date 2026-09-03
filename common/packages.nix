{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    neovim
    git
    htop
  ];
}
