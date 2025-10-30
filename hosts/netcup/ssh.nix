{
  config,
  pkgs,
  ...
}: {
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = ["nixer"];
    };
  };

  users.users."nixer".openssh.authorizedKeys.keys = [
    (builtins.readFile ./assets/rs-server.pub)
  ];
}
