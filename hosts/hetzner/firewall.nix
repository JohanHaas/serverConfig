{
  config,
  pkgs,
  ...
}:
{
  
  networking.firewall = {
    enable = true;
  };


  services.fail2ban = {
    enable = true;
    maxretry = 3;
    bantime = "24h";
    bantime-increment = {
      enable = true;
      formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
      maxtime = "168h"; 
      overalljails = true; 
    };

    jails = {
      sshd.settings = {
        enabled = true;
        port = "22";
        mode = "aggressive";
      };
    };

  };
}
