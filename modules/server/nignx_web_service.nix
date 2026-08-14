{
  flake.modules.nixos.core = { lib, config, ... }: {
    options = {
      web_services = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            domains = lib.mkOption {
              type = lib.types.enum [ "local" "public" "all" ];
              description = "On local, public or all domains";
              default = "all";
            };
   
            root = lib.mkOption {
              type = lib.types.attrs;
              description = "Gets passed into services.nginx.virtualHosts.*.locations.\"/\"";
              default = {};
            };

            locations = lib.mkOption {
              type = lib.types.attrs;
              description = "To set other locations as services.nginx.virtualHosts.*.locations";
              default = {};
            };

            local_self_signed = lib.mkOption {
              type = lib.types.bool;
              default = false;
            }; 
          };
        });
      };
    };

    config = let

      get_webservice = sub_domain: builtins.getAttr sub_domain config.web_services;

      get_domains = sub_domain:
        let svc = get_webservice sub_domain;
        in if svc.domains == "local"  then config.domains.local
        else if svc.domains == "public" then config.domains.public
        else config.domains.all;

      is_domain_local = domain: builtins.elem domain config.domains.local;

      make_vhost = sub_domain: domain:
        let svc = get_webservice sub_domain;
          local = is_domain_local domain;
        in {
          name = "${sub_domain}.${domain}";
          value = {
            enableACME = !local;
            forceSSL   = !local || svc.local_self_signed;
            useACMEHost = lib.mkIf (local && svc.local_self_signed) "${domain}.local";

            listenAddresses = lib.mkIf local [ "10.1.0.2" ];

            locations = {
              "/" = svc.root;
            } // svc.locations;

            serverAliases = [ "www.${sub_domain}.${domain}" ];
          };
        };

      make_self_sign_cert = sub_domain: domain:
        let svc = get_webservice sub_domain;
          local = is_domain_local domain;
        in {
          name = "${sub_domain}.${domain}";
          value = {
            selfSigned = lib.mkIf (local && svc.local_self_signed) true; 
          };
        };
    in {
      services.nginx.virtualHosts = builtins.listToAttrs (
        lib.lists.flatten (
          builtins.map (sub_domain:
            builtins.map (make_vhost sub_domain) (get_domains sub_domain)
          ) (builtins.attrNames config.web_services)
        )
      );

      security.acme.certs = builtins.listToAttrs (
        lib.lists.flatten (
          builtins.map (sub_domain:
            builtins.map (make_self_sign_cert sub_domain) (get_domains sub_domain)
          ) (builtins.attrNames config.web_services)
        )
      );
    };
  };
}
