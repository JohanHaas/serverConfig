{
  config,
  pkgs,
  ...
}:
{
  services.thermald.enable = true;

  boot.kernelParams = [ "acpi_enforce_resources=lax" ];
}
