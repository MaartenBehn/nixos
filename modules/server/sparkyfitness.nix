{ inputs, ... }: {
  flake.modules.nixos.server = { config, ... }: {
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
    };

    web_services."fitness" = {
      domains = "all";
      root = {
        proxyPass = "http://127.0.0.1:8002/"; 
        proxyWebsockets = true; 
      };
    }; 
  };
}
