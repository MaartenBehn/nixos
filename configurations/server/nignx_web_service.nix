{ lib, config, ... }:
{
  options = {
    web_services = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs;
      description = "Get passed into services.nginx.virtualHosts.locations.\"/\"";
    };
  };

  config = {
    services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (sub_domain: 
      builtins.map (domain: {
        name = "${sub_domain}.${domain}"; 
        value = {
          enableACME = domain != "local";
          forceSSL = domain != "local";
          locations."/" = builtins.getAttr sub_domain config.web_services; 
          serverAliases = [
            "www.${sub_domain}.${domain}"
          ];
        };
      }) config.domains.all)
      (builtins.attrNames config.web_services));
  };
}
