{ inputs, ... }: {
  flake.modules.nixos.server = { config, pkgs, ... }: {
    imports = [
      inputs.sparkyfitness.nixosModules.sparkyfitness
    ];

    sops.secrets."sparkyfitness.env" = { 
      owner = "sparkyfitness";  
    };

    services.sparkyfitness = {
      enable = true;
      frontendUrl = "https://fitness.stroby.org";
      environmentFile = config.sops.secrets."sparkyfitness.env".path;
      port = 8002;
      database.package = pkgs.postgresql_17;
      nginx = {
        enable = true;
        virtualHost = "fitness.stroby.org";
      };
    };

    services.nginx.virtualHosts."fitness.stroby.org" = {
      enableACME = true;
      forceSSL = true;

      locations = {
        "/".extraConfig = ''
          add_header X-Content-Type-Options "nosniff";
          proxy_set_header X-Forwarded-Ssl on;
          proxy_set_header Connection "Close";
        '';

        "/assets/".extraConfig = ''
          add_header X-Content-Type-Options "nosniff";
          proxy_set_header X-Forwarded-Ssl on;
          proxy_set_header Connection "Close";
        '';

        "^~ /api/".extraConfig = ''
          add_header X-Content-Type-Options "nosniff";
          proxy_set_header X-Forwarded-Ssl on;
          proxy_set_header Connection "Close";
        '';

        "/health-data".extraConfig = ''
          add_header X-Content-Type-Options "nosniff";
          proxy_set_header X-Forwarded-Ssl on;
          proxy_set_header Connection "Close";
        '';

        "^~ /uploads/".extraConfig = ''
          add_header X-Content-Type-Options "nosniff";
          proxy_set_header X-Forwarded-Ssl on;
          proxy_set_header Connection "Close";
        '';

        "^~ /mcp".extraConfig = ''
          add_header X-Content-Type-Options "nosniff";
          proxy_set_header X-Forwarded-Ssl on;
          proxy_set_header Connection "Close";
        '';
      };
    };
  };
}
