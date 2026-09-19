{ config, pkgs, ... }:
let
  notify = pkgs.writeShellApplication {
    name = "mdadm-notify";
    text = ''
      # mdadm ruft das fuer jedes Ereignis auf, auch fuer Rebuild-Fortschritt;
      # durch kommt nur, was eine Reaktion braucht.
      case "$1" in
        Fail|FailSpare|DegradedArray|SparesMissing|DeviceDisappeared|TestMessage) ;;
        *) exit 0 ;;
      esac

      ${config.services.alerting.command} urgent "RAID $1" "$1 auf $2 ''${3:-}

      $(cat /proc/mdstat)" rotating_light
    '';
  };
in
{
  boot.swraid.mdadmConf = ''
    PROGRAM ${notify}/bin/mdadm-notify
  '';

  # mdmonitor liest mdadm.conf nur beim Start. Ohne den Trigger liefe er nach
  # einem Rebuild mit der alten Config weiter, `--test` wuerde das nicht zeigen.
  systemd.services.mdmonitor.restartTriggers = [ config.environment.etc."mdadm.conf".source ];

  services.alerting = {
    watchUnits = [ "mdmonitor" ];
    diskSpace.mounts = [ "/storage" ];
  };
}
