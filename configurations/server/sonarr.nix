{ local_domain, ... }: {
  services.sonarr = { 
    enable = true;
    openFirewall = false;
  };

  systemd.services.sonarr.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };

  vpnNamespaces.wg = {
    portMappings = [
      { 
        from = 8989;
        to = 8989;
      }
    ];
  };

  services.nginx.virtualHosts = {

    "sonarr.${local_domain}" = {
      locations."/" = {
        proxyPass = "http://192.168.15.1:8989/"; 
      };

      serverAliases = [
        "www.sonarr.${local_domain}"
      ];
    };
  };
}
