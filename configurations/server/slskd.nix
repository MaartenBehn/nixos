{ local_domain, lib, ... }: {
  services.slskd = { 
    enable = true;
    openFirewall = false;
    domain = "slskd.${local_domain}";
  };
  
  systemd.services.slskd = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "mullvad";
    };
  };

  vpnNamespaces.mullvad = {
    portMappings = [
      { 
        from = 5030;
        to = 5030;
      }
    ];
  };

  services.nginx.virtualHosts = {

    "slskd.${local_domain}" = {
      locations."/" = {
        proxyPass = lib.mkForce "http://192.168.15.1:5030/"; 
      };

      serverAliases = [
        "www.slskd.${local_domain}"
      ];
    };
  };
}
