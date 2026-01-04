{ lib, config, ... }:
{
  options = {
    web_services = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          domains = lib.mkOption {
            type = lib.types.enum [ "local" "public" "all" ];
            description = "On local, public or all domains";
            default = "all";
          };
 
          loc = lib.mkOption {
            type = lib.types.attrs;
            description = "Get passed into services.nginx.virtualHosts.locations.\"/\"";
          };
        };
      });
    };
  };

  config = let
      get_webservice = sub_domain: builtins.getAttr sub_domain config.web_services;
      get_domains = sub_domain: if (get_webservice sub_domain).domains == "local" then [ "local" ] else (
        if (get_webservice sub_domain).domains == "public" then config.domains.public else config.domains.all);
    in {
    services.nginx.virtualHosts = builtins.listToAttrs (lib.lists.flatten (builtins.map (sub_domain: 
      builtins.map (domain: {
        name = "${sub_domain}.${domain}"; 
        value = {
          enableACME = domain != "local";
          forceSSL = domain != "local";
          locations."/" = (get_webservice sub_domain).loc; 
          serverAliases = [
            "www.${sub_domain}.${domain}"
          ];
        };
      }) (get_domains sub_domain))
      (builtins.attrNames config.web_services)));
  };
}
