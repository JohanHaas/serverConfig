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

    hashedPassword = "$6$21Wa63S6fVhUrDQl$l0JkGp6x74IgMRosN0Rgz0kAI2dbLmxLQk.3grqYUIhIbB1brIqjwy4orXrX86Z5SF2RvvKSdbKy2fBVTclH..";
    openssh.authorizedKeys.keys = [
      (builtins.readFile ./ssh/admin.pub)
    ];
  };

  users.users.wireguard = {
    isNormalUser = true;
  };
}
