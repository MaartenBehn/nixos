{ local_domain, ... }: {
  services.prowlarr = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "wg";
    };

    enable = true;
    openFirewall = false;
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
