{
  config,
  pkgs,
  ...
}: let
  dir = builtins.dirOf __curPos.file;
in {
  users.users.nixer = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = with pkgs; [
      tree
    ];

    hashedPassword = "$y$j9T$zpBx1gFC6rnIaO0h1Z/.2.$WLT53HkIDSKTxQrbcr1Af135OPz/q3oCC1ee2TVkvf0";
  };
}
