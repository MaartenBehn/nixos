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
            enableACME = !local || svc.local_self_signed;
            forceSSL   = !local || svc.local_self_signed;

            listenAddresses = lib.mkIf local [ "10.1.0.2" "10.2.0.1" "fd00:11::2" "fd00:12::1" ];

            locations = {
              "/" = svc.root;
            } // svc.locations;

            serverAliases = [ "www.${sub_domain}.${domain}" ];
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
    };
  };
}
