{
  flake.modules.nixos.core = {config, ... }: {
    # configuration.nix or secrets.nix
    sops.secrets.meili_master_key = {
      format = "yaml";
      # Ensure both Meilisearch and Wanderer system users can access it if needed
      mode = "0440";
      owner = "wanderer";
      group = "wanderer";
    };

    services.wanderer = {
      enable = true;
      port = 8003;
      origin = "http://192.168.1.100:3000"; # Your server IP / Domain
      dataDir = "/var/lib/wanderer";
      masterKeyEnvironmentFile = config.sops.secrets.meili_master_key.path;
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
