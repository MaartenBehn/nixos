{ pkgs, domain, ... }:
{
  services.static-web-server = {
    enable = true;
    root = "/home/stroby/dev/obsidian_export/quartz/public/";
    listen = "127.0.0.1:8082";
  };

  systemd.services.obsidian_export-updater = {
    path = with pkgs; [
      bash
      rustup
      nodejs
      git
      gcc
    ];
    script = "cd /home/stroby/dev/obsidian_export/ && sh rebuild.sh";
    #startAt = "hourly";  
    startAt = "daily";  
    wantedBy = [ "network-online.target" ];
  };
  systemd.timers.obsidian_export-updater.timerConfig.RandomizedDelaySec = "15m";

  services.nginx.virtualHosts = let
    SSL = {
      enableACME = true;
      forceSSL = true;
    }; in {
      
    "notes.${domain}" = (SSL // {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8082/";
      };

      serverAliases = [
        "www.notes.${domain}"
      ];
    });
  };
}
