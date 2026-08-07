{
  flake.modules.nixos.core = {config, ... }: {
    # configuration.nix or secrets.nix
    
    services.wanderer = {
      enable = true;
      port = 8003;
      origin = "https://wanderer.stroby.org";
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
  };
}
