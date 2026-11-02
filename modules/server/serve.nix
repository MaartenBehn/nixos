{
  my.secrets.server."serve_asus_private_key" = {
    bitwarden = { name = "Serve Asus"; field = "private_key"; };
  };

  flake.modules.nixos.server = { config, ... }: {
    
    services.nix-serve = {
      enable = true;
      secretKeyFile = config.my.secrets."serve_asus_private_key".path;
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
