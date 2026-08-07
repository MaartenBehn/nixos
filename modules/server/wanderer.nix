{
  flake.modules.nixos.core = {config, ... }: {
    # configuration.nix or secrets.nix
    
    services.wanderer = {
      enable = true;
      port = 8003;
      pbPort = 8004;
      origin = "https://wanderer.stroby.org";
      publicPbUrl = "http://wanderer-db.local";
      dataDir = "/var/lib/wanderer";
      meiliKeySopsField = "meili_master_key";
    };

    web_services."wanderer" = {
      domains = "all";
      root = {
        proxyPass = "http://127.0.0.1:8003";
        proxyWebsockets = true;    
      };
    };

    web_services."wanderer-db" = {
      domains = "local";
      root = {
        proxyPass = "http://127.0.0.1:8004";
        proxyWebsockets = true;    
      };
    };
  };
}
