{
  description = "NixOS configs for nix-vps (Hetzner) and nix-home-server";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, disko, sops-nix, ... }: let
    # `host` ist der Name in nixosConfigurations, nicht networking.hostName.
    mkHost = host: diskoConfig: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit sops-nix host; };
      modules = [
        ./hosts/${host}
        disko.nixosModules.disko
        diskoConfig
      ];
    };
  in {
    nixosConfigurations = {
      gateway = mkHost "gateway" ./disko/hetzner-config.nix;
      homelab = mkHost "homelab" ./disko/home-config.nix;
    };
  };
}
