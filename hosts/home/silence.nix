{
  config,
  pkgs,
  ...
}:
{
  powerManagement.cpuFreqGovernor = "powersave";
  services.thermald.enable = true;

  boot.kernelParams = [ "acpi_enforce_resources=lax" ];

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "power";
      CPU_BOOST_ON_AC = 0;
      #CPU_MAX_PERF_ON_AC = 70;
      RUNTIME_PM_ON_AC = "auto";
      PCIE_ASPM_ON_AC = "powersupersave";
    };
  };

}
