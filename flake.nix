{
  description = "NixOS configs for nix-vps (Hetzner) and nix-home-server";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Attribute names match networking.hostName, so `nixos-rebuild switch
  # --flake .` picks the right host by itself on each machine.
  outputs = { nixpkgs, disko, ... }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      "nix-vps" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/gateway

          disko.nixosModules.disko
          ./disko/hetzner-config.nix
        ];
      };
      "nix-home-server" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/homelab

          disko.nixosModules.disko
          ./disko/home-config.nix
        ];
      };
    };
  };
}
