{ config, ... }:
{
  # Zweiter Alarmweg neben ntfy, unabhaengig vom Gateway. Stellt `sendmail`
  # bereit, ueber das `alert` Mails verschickt.
  programs.msmtp = {
    enable = true;
    setSendmail = true;
    accounts.default = {
      host = "smtp.protonmail.ch";
      port = 587;
      tls = true;
      auth = true;
      user = "alerts@johanhaas.de";
      from = "alerts@johanhaas.de";
      # Proton-SMTP-Token, gilt nur fuer alerts@.
      passwordeval = "cat ${config.sops.secrets.smtp-token.path}";
    };
  };

  sops.secrets.smtp-token = { };
}
