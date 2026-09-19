{ config, lib, ... }:
let
  cfg = config.services.deploy-runner;

  # Muss auf dem Host und im Container derselbe Pfad sein: compose loest
  # ${PWD}/caddy/conf usw. in den Bind-Mounts auf dem Host auf, nicht im
  # Runner-Container. Nicht unter /tmp, das wird aufgeraeumt.
  workDir = "/var/lib/github-runner/work";
in
{
  options.services.deploy-runner = {
    enable = lib.mkEnableOption "GitHub-Runner fuer deploy.yml";
    labels = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Labels, ueber die deploy.yml diesen Host anspricht.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.labels != [ ];
        message = "services.deploy-runner.labels ist leer, deploy.yml wuerde diesen Runner nie finden.";
      }
    ];

    virtualisation.docker.enable = true;

    systemd.tmpfiles.rules = [
      "d /etc/github-runner 0700 root root -"
      "d ${workDir} 0700 root root -"
    ];

    virtualisation.oci-containers = {
      backend = "docker";
      containers.github-runner = {
        image = "myoung34/github-runner:2.337.0";
        # Enthaelt nur ACCESS_TOKEN=<fine-grained PAT>; root:root 0600.
        environmentFiles = [ "/etc/github-runner/env" ];
        environment = {
          RUNNER_SCOPE = "repo";
          REPO_URL = "https://github.com/JohanHaas/homelab-docker";
          # Fester Name: der Runner ersetzt beim Start seinen alten Eintrag,
          # statt nach jedem Neustart einen neuen anzulegen.
          RUNNER_NAME = config.networking.hostName;
          LABELS = lib.concatStringsSep "," cfg.labels;
          RUNNER_WORKDIR = workDir;
        };
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
          "${workDir}:${workDir}"
        ];
      };
    };
  };
}
