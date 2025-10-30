{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
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
          ./hosts/common
          ./hosts/netcup
        ];
      };
    };
  };
}
