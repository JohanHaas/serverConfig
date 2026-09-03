{ config, pkgs, ... }:

let
  hostName = "gateway";
  runnerLabels = "gateway,self-hosted";
  workDir = "/root/docker";
  composeFile = "/root/docker/runner/compose.yaml";
in
{
  systemd.services."${hostName}-runner" = {
    description = "GitHub Actions Runner - ${hostName}";
    after = [ "docker.service" "network-online.target" ];
    requires = [ "docker.service" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "simple";
      User = "root";
      WorkingDirectory = workDir;

      # Lädt Secrets aus .env Datei (nicht in der Config speichern!)
      EnvironmentFile = "/etc/github-runner/${hostName}.env";

      # Weitere Umgebungsvariablen
      Environment = [
        "RUNNER_LABELS=${runnerLabels}"
        "PATH=/run/current-system/sw/bin:/run/wrappers/bin:/usr/bin:/bin"
      ];

      ExecStart = "${pkgs.docker}/bin/docker compose -f ${composeFile} up";
      Restart = "always";
      RestartSec = 10;
    };

    wantedBy = [ "multi-user.target" ];
  };

  # Stelle sicher dass das Verzeichnis für .env Dateien existiert
  system.activationScripts.githubRunnerDir = ''
    mkdir -p /etc/github-runner
    chmod 700 /etc/github-runner
  '';
}
