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
    ignoreIP = [
      "127.0.0.1/8"
      "192.168.178.0/24" 
      "10.100.0.0/24"    
    ];
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
