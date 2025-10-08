{ local_domain, ... }: {
  services.jellyseerr = {
    enable = true;
    port = 5055;
  };

  systemd.services.jellyseerr.vpnConfinement = {
    enable = true;
    vpnNamespace = "mullvad";
  };

  services.nginx.virtualHosts = {

    "seerr.${local_domain}" = {
      locations."/" = {
        proxyPass = "http://192.168.15.1:5055/"; 
      };

      serverAliases = [
        "www.seerr.${local_domain}"
      ];
    };
  };
} 
