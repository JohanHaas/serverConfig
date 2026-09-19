{ config, lib, pkgs, ... }:
let
  cfg = config.services.alerting;
  host = config.networking.hostName;

  # alert <urgent|high|default|low> <titel> <text> [tags]
  alert = pkgs.writeShellApplication {
    name = "alert";
    runtimeInputs = [ pkgs.curl ];
    text = ''
      prio="$1" title="${host}: $2" body="$3" tags="''${4:-}"

      ntfy_ok=0
      if curl -sf --max-time 10 \
          -H "Authorization: Bearer $(cat ${cfg.ntfyTokenFile})" \
          -H "Title: $title" -H "Priority: $prio" -H "Tags: $tags" \
          --data-binary "$body" ${cfg.ntfyUrl} >/dev/null; then
        ntfy_ok=1
      fi

      # Wichtiges immer auch per Mail; der Rest nur, wenn ntfy nicht ging
      # (ntfy laeuft auf dem Gateway und kann selbst betroffen sein).
      if [ "$prio" = urgent ] || [ "$prio" = high ] || [ "$ntfy_ok" = 0 ]; then
        printf 'Subject: %s\n\n%s\n' "$title" "$body" | ${cfg.sendmail} ${cfg.mailTo}
      fi
    '';
  };
  alertBin = "${alert}/bin/alert";
in
{
  options.services.alerting = {
    command = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = alertBin;
      description = "Pfad zum alert-Skript, fuer andere Module.";
    };
    ntfyUrl = lib.mkOption {
      type = lib.types.str;
      default = "https://ntfy.johanhaas.de/alerts";
    };
    ntfyTokenFile = lib.mkOption {
      type = lib.types.str;
      default = config.sops.secrets.ntfy-token.path;
    };
    mailTo = lib.mkOption {
      type = lib.types.str;
      default = "alerts@johanhaas.de";
    };
    sendmail = lib.mkOption {
      type = lib.types.str;
      default = "/run/wrappers/bin/sendmail";
    };
    watchUnits = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Units, deren Ausfall (Zustand failed) einen Alarm ausloest.";
    };
    diskSpace = {
      mounts = lib.mkOption { type = lib.types.listOf lib.types.str; };
      threshold = lib.mkOption {
        type = lib.types.int;
        default = 90;
      };
    };
  };

  config = lib.mkMerge [
    {
      sops.secrets.ntfy-token = { };
      environment.systemPackages = [ alert ];

      # Als Definitionen statt Defaults, damit Hosts Eintraege ergaenzen koennen.
      services.alerting.watchUnits = [ "docker" "docker-github-runner" "fail2ban" "sshd" "tailscaled" ];
      services.alerting.diskSpace.mounts = [ "/" ];

      systemd.services = lib.genAttrs cfg.watchUnits (_: {
        onFailure = [ "alert-unit-failure@%n.service" ];
      });
    }

    {
      systemd.services."alert-unit-failure@" = {
        serviceConfig.Type = "oneshot";
        scriptArgs = "%i";
        script = ''
          ${alertBin} high "$1 fehlgeschlagen" "$(journalctl -u "$1" -n 20 --no-pager -o cat)" x
        '';
      };

      # Alarm einmal beim Ueberschreiten, erst wieder nach Unterschreiten um 5 %.
      systemd.services.alert-disk-space = {
        serviceConfig = {
          Type = "oneshot";
          StateDirectory = "alert-disk-space";
        };
        script = ''
          for m in ${lib.escapeShellArgs cfg.diskSpace.mounts}; do
            pct=$(df --output=pcent "$m" | tail -n 1 | tr -dc 0-9)
            flag="$STATE_DIRECTORY/$(systemd-escape --path "$m")"
            if [ "$pct" -ge ${toString cfg.diskSpace.threshold} ]; then
              if [ ! -e "$flag" ]; then
                ${alertBin} high "Speicher $m zu $pct % voll" "$(df -h "$m")" floppy_disk
                touch "$flag"
              fi
            elif [ "$pct" -lt ${toString (cfg.diskSpace.threshold - 5)} ]; then
              rm -f "$flag"
            fi
          done
        '';
      };
      systemd.timers.alert-disk-space = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "hourly";
          Persistent = true;
        };
      };
    }

    (lib.mkIf config.virtualisation.docker.enable {
      # Einmal pro Vorfall; der Marker faellt weg, sobald der Container wieder
      # gesund ist.
      systemd.services.alert-containers = {
        path = [ config.virtualisation.docker.package pkgs.jq ];
        serviceConfig = {
          Type = "oneshot";
          StateDirectory = "alert-containers";
        };
        script = ''
          bad=$(docker ps --filter health=unhealthy --format '{{.Names}}')
          for c in $bad; do
            [ -e "$STATE_DIRECTORY/$c" ] && continue
            out=$(docker inspect --format '{{json .State.Health}}' "$c" | jq -r '.Log[-1].Output' | tail -c 1000)
            ${alertBin} high "Container $c unhealthy" "''${out:-Healthcheck fehlgeschlagen, ohne Ausgabe}" warning
            touch "$STATE_DIRECTORY/$c"
          done
          for f in "$STATE_DIRECTORY"/*; do
            [ -e "$f" ] || continue
            printf '%s\n' "$bad" | grep -qx "$(basename "$f")" || rm -f "$f"
          done
        '';
      };
      systemd.timers.alert-containers = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnBootSec = "5min";
          OnUnitActiveSec = "5min";
        };
      };
    })
  ];
}
