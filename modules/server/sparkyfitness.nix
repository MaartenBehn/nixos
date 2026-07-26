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

      locations."/".extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        add_header X-Content-Type-Options "nosniff";
        proxy_set_header X-Forwarded-Ssl on;
      '';
    };
  };
}
