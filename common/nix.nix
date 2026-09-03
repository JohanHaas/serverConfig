{ ... }:
{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "admin" ];
    auto-optimise-store = true;
  };
}
