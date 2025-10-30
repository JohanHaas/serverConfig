{
  config,
  pkgs,
  ...
}: let
  dir = builtins.dirOf __curPos.file;
in {
  users.users = {
    nixer = {
      #root user
      isNormalUser = true;
      extraGroups = ["wheel"];
      packages = with pkgs; [
      ];

      hashedPassword = "$y$j9T$/UVVk2FuAwBY3YQRO/enq/$AOQhuzSHNjz/MEB.fQX/fiFuKM.iDyYlLfFilQq4/FD";
      openssh.authorizedKeys.keys = [
        (builtins.readFile ./assets/ssh-keys/rootUser.pub)
      ];
    };

    wireguard = {
      #wireguard user
      isNormalUser = true;
      extraGroups = [];
      packages = with pkgs; [
      ];

      hashedPassword = "$y$j9T$Xq6ayPtlMWkOJNHRxrTsh0$e7cNlZ3Bz2qHMgZ7h3fge9KD6yHD88lnTec7U6GOXF5";
      openssh.authorizedKeys.keys = [
        (builtins.readFile ./assets/ssh-keys/vpnUser.pub)
      ];
    };
  };
}
