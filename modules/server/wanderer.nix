{ inputs, ... }: {
  flake.modules.nixos.server = {config, ... }: {

    imports = [
      inputs.wanderer.nixosModules.default
    ];
    
    services.wanderer = {
      enable = true;
      port = 8003;
      origin = "https://wanderer.stroby.org";
      data_dir = "/var/lib/wanderer";

      pocketbase = {
        port = 8004;
        public_url = "http://wanderer-db.local";
      };

      meilisearch = {
        enable = true;
        port = 7700;
      };

      sops = {
        enable = true;
        meili_key_field = "meili_master_key";
        pocketbase_encryption_key_field = "wanderer_pb_encryption_key";
      };
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
