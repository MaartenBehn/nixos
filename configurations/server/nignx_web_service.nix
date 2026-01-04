{ lib, config, ... }:
{
  options = {
    web_services = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule ({ ... }: {
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
      }));
    };
  };

  config = {

    services.nginx.virtualHosts = builtins.map (web_service: 
      builtins.listToAttrs (builtins.map (domain: {
        name = "${web_service.sub_domain}.${domain}"; 
        value = {
          enableACME = domain != "local";
          forceSSL = domain != "local";
          locations."/" = web_service.config; 
          serverAliases = [
            "www.${web_service.sub_domain}.${domain}"
          ];
        };
      }) config.domains.all)
      config.web_services);
  };
}
