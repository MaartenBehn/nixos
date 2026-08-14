{ inputs, ... }: {
  flake.modules.nixos.server = {config, ... }: {

    imports = [
      "${inputs.nixpkgs-wanderer}/nixos/modules/services/web-apps/wanderer.nix"

      {
        nixpkgs.overlays = [
          (final: prev: {
            wanderer = inputs.nixpkgs-wanderer.legacyPackages.${prev.system}.wanderer;
            wanderer-db = inputs.nixpkgs-wanderer.legacyPackages.${prev.system}.wanderer-db;
          })
        ];
      }
    ];

    sops = { 
      secrets = {
        "meili_master_key" = { mode = "0444"; };
        "wanderer_pb_encryption_key" = { mode = "0444"; };
      };

      templates."wanderer.env" = {
        owner = "wanderer";
        group = "wanderer";
        content = ''
          MEILI_MASTER_KEY=${config.sops.placeholder."meili_master_key"}
          POCKETBASE_ENCRYPTION_KEY=${config.sops.placeholder."wanderer_pb_encryption_key"}
        '';
      };
    };
    
    services.wanderer = {
      enable = true;
      port = 8003;
      origin = "https://wanderer.stroby.org";
      dataDir = "/var/lib/wanderer";
      environmentFile = config.sops.templates."wanderer.env".path;

      pocketbase = {
        port = 8004;
        publicUrl = "http://wanderer-db.local";
      };

      meilisearch = {
        enable = true;
        port = 7700;
        masterKeyFile = config.sops.secrets."meili_master_key".path; 
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
