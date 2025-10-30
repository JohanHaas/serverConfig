{
  config,
  pkgs,
  ...
}: {
  nix.settings.trusted-users = ["nixer"];
  nix.settings.experimental-features = ["nix-command" "flakes"];

  time.timeZone = "Europe/Amsterdam";

  environment.systemPackages = with pkgs; [
    vim
    git
    tree
  ];

  system.stateVersion = "25.05";
}
