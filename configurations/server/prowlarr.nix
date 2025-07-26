{ local_domain, ... }: {
  services.prowlarr = { 
    enable = true;
    openFirewall = false;
  };

  systemd.services.prowlarr.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };

  vpnNamespaces.wg = {
    portMappings = [
      { 
        from = 9696;
        to = 9696;
      }
    ];
  };

  services.nginx.virtualHosts = {

    "prowlarr.${local_domain}" = {
      locations."/" = {
        proxyPass = "http://192.168.15.1:9696/"; 
      };

      serverAliases = [
        "www.prowlarr.${local_domain}"
      ];
    };
  };

  services.homepage-dashboard = { 
    services = [
      {
        Media = [
          {
            Prowlarr = {
              #icon: "img."
              href = "http://prowlarr.home";
              description = "Torrent Search Engine";
              widget = {
                type = "prowlarr";
                url = "http://prowlarr.home";
                key = "08d09cc6bb6f45419174b35542808b4d";
              };
            };
          }
        ];
      }
    ];
  };

}
