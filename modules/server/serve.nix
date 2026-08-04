{
  flake.modules.nixos.server = { config, ... }: {
    sops.secrets."serve/asus-stroby/private_key" = {
      mode = "0400";
      owner = "root";
    };

    services.nix-serve = {
      enable = true;
      secretKeyFile = config.sops.secrets."serve/asus-stroby/private_key".path;
      bindAddress = "127.0.0.1";
      port = 5000;
    }; 

    web_services."cache" = {
      domains = "all";
      root = {
        proxyPass = "http://127.0.0.1:5000";
        extraConfig = ''
          proxy_cache_valid 200 302 60m;
          proxy_read_timeout 300s;
          proxy_send_timeout 300s;
        '';      
      };
    };
  };
}
