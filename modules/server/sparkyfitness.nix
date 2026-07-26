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

          client_body_buffer_size 128k;

          proxy_connect_timeout 90;
          proxy_send_timeout 90;
          proxy_read_timeout 90;
          proxy_buffers 4 32k;
          client_max_body_size 0;
        '';

        "/assets/".extraConfig = ''
          add_header X-Content-Type-Options "nosniff";
          proxy_set_header X-Forwarded-Ssl on;

          client_body_buffer_size 128k;

          proxy_connect_timeout 90;
          proxy_send_timeout 90;
          proxy_read_timeout 90;
          proxy_buffers 4 32k;
          client_max_body_size 0;
        '';

        "^~ /api/".extraConfig = ''
          add_header X-Content-Type-Options "nosniff";
          proxy_set_header X-Forwarded-Ssl on;

          client_body_buffer_size 128k;

          proxy_connect_timeout 90;
          proxy_send_timeout 90;
          proxy_read_timeout 90;
          proxy_buffers 4 32k;
          client_max_body_size 0;
        '';

        "/health-data".extraConfig = ''
          add_header X-Content-Type-Options "nosniff";
          proxy_set_header X-Forwarded-Ssl on;

          client_body_buffer_size 128k;

          proxy_connect_timeout 90;
          proxy_send_timeout 90;
          proxy_read_timeout 90;
          proxy_buffers 4 32k;
          client_max_body_size 0;
        '';

        "^~ /uploads/".extraConfig = ''
          add_header X-Content-Type-Options "nosniff";
          proxy_set_header X-Forwarded-Ssl on;

          client_body_buffer_size 128k;

          proxy_connect_timeout 90;
          proxy_send_timeout 90;
          proxy_read_timeout 90;
          proxy_buffers 4 32k;
          client_max_body_size 0;
        '';

        "^~ /mcp".extraConfig = ''
          add_header X-Content-Type-Options "nosniff";
          proxy_set_header X-Forwarded-Ssl on;

          client_body_buffer_size 128k;

          proxy_connect_timeout 90;
          proxy_send_timeout 90;
          proxy_read_timeout 90;
          proxy_buffers 4 32k;
          client_max_body_size 0;
        '';
      };
    };
  };
}
