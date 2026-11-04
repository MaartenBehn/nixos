{
  flake.modules.nixos.server = { config, ... }: {
    services.nginx.virtualHosts.${config.domains.public} = {
      useACMEHost = config.domains.public;
      forceSSL = true;
      locations."= /" = {
        extraConfig = ''
          default_type text/html;
          return 200 '<!DOCTYPE html><html><head><title></title></head><body></body></html>';
        '';
      };

      # Catch-all for EVERY other path
      locations."/" = {
        return = "444"; 
      };

      serverAliases = [
        "www.${config.domains.public}"
      ];
    };
  };
}
