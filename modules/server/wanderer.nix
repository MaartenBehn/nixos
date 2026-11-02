{ inputs, ... }: {
  my.secrets.server = {
    "meili_master_key" = { 
      bitwarden = { name = "Melisearch"; field = "Master Key"; };
      mode = "0444"; 
    };
    "wanderer_pb_encryption_key" = { 
      bitwarden = { name = "Wanderer"; field = "pb_encryption_key"; };
      mode = "0444"; 
    };
    "wanderer_proxy_secret" = { 
      bitwarden = { name = "Wanderer"; field = "proxy_secret"; };
      mode = "0444"; 
    };
  };

  flake.modules.nixos.server = {config, ... }: {

    imports = [
      "${inputs.nixpkgs-wanderer}/nixos/modules/services/web-apps/wanderer.nix"

      {
        nixpkgs.overlays = [
          (final: prev: {
            wanderer = inputs.nixpkgs-wanderer.legacyPackages.${prev.system}.wanderer;
            wanderer-web = inputs.nixpkgs-wanderer.legacyPackages.${prev.system}.wanderer-web;
          })
        ];
      }
    ];
    
    services.meilisearch.masterKeyFile = config.my.secrets."meili_master_key".path;

    services.wanderer = {
      enable = true;
      host = "127.0.0.1";
      port = 8003;
      openFirewall = false;
      
      pocketbase = {
        host = "127.0.0.1";
        port = 8004;
      };

      meilisearch.enable = true;

      settings = {
        ORIGIN = "https://wanderer.stroby.org";
        PUBLIC_DISABLE_SIGNUP = false;
        PUBLIC_PRIVATE_INSTANCE = false;
        PUBLIC_POCKETBASE_URL = "http://wanderer-db.local";
      };
      secrets = {
        POCKETBASE_ENCRYPTION_KEY = config.my.secrets."wanderer_pb_encryption_key".path;
        POCKETBASE_PROXY_SECRET = config.my.secrets."wanderer_proxy_secret".path;
      };
    };

    web_services."wanderer" = {
      domains = "all";
      root = {
        proxyPass = "http://127.0.0.1:${toString config.services.wanderer.port}";
        proxyWebsockets = true;    
      };
    };

    web_services."wanderer-db" = {
      domains = "local";
      root = {
        proxyPass = "http://127.0.0.1:${toString config.services.wanderer.pocketbase.port}";
        proxyWebsockets = true;    
      };
    };
  };
}
