{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    disko,
    ...
  }: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
      ];
    };
  in {
    nixosConfigurations = {
      "netcup" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/netcup

          disko.nixosModules.disko
          ./disko/disko-config.nix
        ];
      };
    };
  };
}
