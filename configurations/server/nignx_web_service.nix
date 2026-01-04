{ lib, config, ... }:
{
  options = {
    web_services = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule ({ config, ... }: {
        options = {
          sub_domain = lib.mkOption {
            description = "The subdomain in <this>.stroby.org";
            type = lib.types.str;
          };

          config = lib.mkOption {
            description = "Get passed into services.nginx.virtualHosts.locations.\"/\"";
            type = lib.types.attrs;
          };
        };

        config = {
          services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
              name = "${config.sub_domain}.${domain}"; 
              value = {
                enableACME = domain != "local";
                forceSSL = domain != "local";
                locations."/" = config.config; 
                serverAliases = [
                  "www.${config.sub_domain}.${domain}"
                ];
              };
            }) config.domains.all);
        };
      }));
    };
  };
}
