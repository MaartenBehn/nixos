{ inputs, ... }: {
  flake.modules.nixos.server = { config, pkgs, ... }: let 
    default_borg_settings = import ./_borg_settings.nix;
  in {
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

      extraConfig = ''
        access_log /var/log/nginx/sparkyfitness-access.log;
        error_log /var/log/nginx/sparkyfitness-error.log warn;
      '';

      locations = {
        "/".extraConfig = ''
          add_header X-Content-Type-Options "nosniff";
          proxy_set_header X-Forwarded-Ssl on;
          proxy_set_header Connection "Close";

          client_body_buffer_size 128k;

          proxy_connect_timeout 90;
          proxy_send_timeout 90;
          proxy_read_timeout 90;
          proxy_buffers 4 32k;
          client_max_body_size 0;
          proxy_pass_header Authorization;

          proxy_redirect off;
        '';

        "/assets/".extraConfig = ''
          add_header X-Content-Type-Options "nosniff";
          proxy_set_header X-Forwarded-Ssl on;
          proxy_set_header Connection "Close";

          client_body_buffer_size 128k;

          proxy_connect_timeout 90;
          proxy_send_timeout 90;
          proxy_read_timeout 90;
          proxy_buffers 4 32k;
          client_max_body_size 0;
          proxy_pass_header Authorization;

          proxy_redirect off;
        '';

        "^~ /api/".extraConfig = ''
          add_header X-Content-Type-Options "nosniff";
          proxy_set_header X-Forwarded-Ssl on;
          proxy_set_header Connection "Close";

          client_body_buffer_size 128k;

          proxy_connect_timeout 90;
          proxy_send_timeout 90;
          proxy_read_timeout 90;
          proxy_buffers 4 32k;
          client_max_body_size 0;
          proxy_pass_header Authorization;

          proxy_redirect off;
        '';

        "/health-data".extraConfig = ''
          add_header X-Content-Type-Options "nosniff";
          proxy_set_header X-Forwarded-Ssl on;
          proxy_set_header Connection "Close";

          client_body_buffer_size 128k;

          proxy_connect_timeout 90;
          proxy_send_timeout 90;
          proxy_read_timeout 90;
          proxy_buffers 4 32k;
          client_max_body_size 0;
          proxy_pass_header Authorization;

          proxy_redirect off;
        '';

        "^~ /uploads/".extraConfig = ''
          add_header X-Content-Type-Options "nosniff";
          proxy_set_header X-Forwarded-Ssl on;
          proxy_set_header Connection "Close";

          client_body_buffer_size 128k;

          proxy_connect_timeout 90;
          proxy_send_timeout 90;
          proxy_read_timeout 90;
          proxy_buffers 4 32k;
          client_max_body_size 0;
          proxy_pass_header Authorization;

          proxy_redirect off;
        '';

        "^~ /mcp".extraConfig = ''
          add_header X-Content-Type-Options "nosniff";
          proxy_set_header X-Forwarded-Ssl on;
          proxy_set_header Connection "Close";

          client_body_buffer_size 128k;

          proxy_connect_timeout 90;
          proxy_send_timeout 90;
          proxy_read_timeout 90;
          proxy_buffers 4 32k;
          client_max_body_size 0;
          proxy_pass_header Authorization;

          proxy_redirect off;
        '';
      };
    };


    services.borgbackup.jobs.fritz_behns_sparkyfitness = default_borg_settings // {
      group = "sparkyfitness";
      paths = "/var/lib/sparkyfitness"; 
      repo = "ssh://Stroby@192.168.178.39/volume1/BackUp/asus_server/sparkyfitness";
      startAt = "*-*-* 06:00";
    };

    services.borgbackup.jobs.proxy_sparkyfitness = default_borg_settings // {
      group = "sparkyfitness";
      paths = "/var/lib/sparkyfitness";
      repo = "ssh://root@138.199.203.38/backup/sparkyfitness";
      startAt = "*-*-* 06:00";
    };
   
    systemd.services.borgbackup-job-fritz_behns_sparkyfitness = {
      vpnConfinement = {
        enable = true;
        vpnNamespace = "fritz";
      };

      onFailure = [ "unit-status@%n.service" ];
      requires = [ "fritz_behns_vpn_check.service" ];
      after = [ "fritz_behns_vpn_check.service" ];
    };

    systemd.services.borgbackup-job-proxy_sparkyfitness.onFailure = [ "unit-status@%n.service" ];
  };
}
