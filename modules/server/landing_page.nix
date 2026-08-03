{
  flake.modules.nixos.server = {
    services.nginx.virtualHosts."stroby.org" = {
      enableACME = true;
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
        "www.stroby.org"
      ];
    };
  };
}
