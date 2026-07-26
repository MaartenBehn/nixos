{
  flake.modules.nixos.server = {
    services.wger = {
      enable = true;
      domain = "wger.stroby.org";
      secretKeySecret = "wger_secret_key"; # Matches your sops secret entry
      timeZone = "Europe/Berlin";
      port = 8001;
    };

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;

      virtualHosts."wger.stroby.org" = {
        forceSSL = true;
        enableACME = true;

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

        locations."/" = {
          proxyPass = "http://127.0.0.1:8001";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };

    # Allow Nginx worker to read static/media owned by wger group
    users.users.nginx.extraGroups = [ "wger" ];
  };
}
