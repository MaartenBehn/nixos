{
  flake.modules.nixos.server = {config, ... }: {

    sops.secrets."wger/key" = {
      owner = "wger";
      group = "wger";
      mode = "0400";
    };

    services.wger = {
      enable = true;
      domain = "wger.stroby.org";
      port = 8001;
      secretKeyFile = config.sops.secrets."wger/key".path;       
      timeZone = "Europe/Berlin";
      release = "2.6";
    };

    web_services."wger" = {
      domains = "all";
      root = {
        proxyPass = "http://127.0.0.1:8001";
        proxyWebsockets = true;
        extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };

      locations."/static/" = {
        alias = "/var/lib/wger/static/";
        extraConfig = ''
            expires 30d;
            add_header Cache-Control "public, no-transform";
        '';
      };

      locations."/media/" = {
        alias = "/var/lib/wger/media/";
      };
    }; 
    
    # Allow Nginx worker to read static/media owned by wger group
    users.users.nginx.extraGroups = [ "wger" ];
  };
}
