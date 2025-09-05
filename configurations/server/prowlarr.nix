{ local_domain, ... }: {
  services.prowlarr = { 
    enable = true;
    openFirewall = false;
  };

  systemd.services.prowlarr.vpnConfinement = {
    enable = true;
    vpnNamespace = "mullvad";
  };

  vpnNamespaces.mullvad = {
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
}
