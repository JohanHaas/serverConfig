{
  config,
  pkgs,
  ...
}:
{
  users.users.admin = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "podman"
    ];

    hashedPassword = "$6$xPWspkIXn3a.TbXC$9p33I.MyzR9cN1FzEWzIJv/Pr6SlGZqT9b6UmHznhqMZx51dKbpwwwvdJDtYa/EPqsfoE3rZF3D7/C.Em/sGg/";
    openssh.authorizedKeys.keys = [
      (builtins.readFile ./ssh/admin.pub)
    ];
  };
}
