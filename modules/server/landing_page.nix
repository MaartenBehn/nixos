{
  flake.modules.nixos.server = { config, ... }: {
    services.nginx.virtualHosts.${config.domains.public} = {
      useACMEHost = config.domains.public;
      forceSSL = true;
      listenAddresses = [ "0.0.0.0" "10.1.0.2" "10.2.0.1" "[::]" "[fd00:11::2]" "[fd00:12::1]" ];
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
