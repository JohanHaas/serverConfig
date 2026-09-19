{ config, pkgs, ... }:
let
  notify = pkgs.writeShellScript "smartd-alert" ''
    exec ${config.services.alerting.command} urgent \
      "Platte $SMARTD_DEVICE: $SMARTD_FAILTYPE" "$SMARTD_FULLMESSAGE" floppy_disk
  '';
in
{
  # Warnt, bevor eine Platte ausfaellt; mdadm meldet erst den Ausfall selbst.
  services.smartd = {
    enable = true;
    # Eigene Benachrichtigung ueber `alert` statt Mail/Wall des Moduls.
    notifications = {
      mail.enable = false;
      wall.enable = false;
    };
    # Kurzer Selbsttest sonntags 3 Uhr, langer am Monatsersten 4 Uhr.
    defaults.autodetected = "-a -o on -s (S/../../7/03|L/../01/./04) -m <nomailer> -M exec ${notify}";
  };

  services.alerting.watchUnits = [ "smartd" ];
}
