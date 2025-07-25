{ pkgs, local_domain, ... }: {
  systemd.services.jackett = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "wg";
    };

    path = with pkgs; [
      curl
      jackett
    ];
    script = "
    curl curl ipinfo.io;
    jackett;
    ";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.User = "stroby";
  };

  systemd.services.flaresolverr.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };

  services.flaresolverr = {
    enable = true;
  };

  vpnNamespaces.wg = {
    portMappings = [
      { 
        from = 9117;
        to = 9117;
      }
      { 
        from = 8191;
        to = 8191;
      }
    ];
  };

  services.nginx.virtualHosts = { 
    "jackett.${local_domain}" = {
      locations."/" = {
        proxyPass = "http://192.168.15.1:9117/"; 
      };

      serverAliases = [
        "www.jackett.${local_domain}"
      ];
    };

    "flaresolverr.${local_domain}" = {
      locations."/" = {
        proxyPass = "http://192.168.15.1:8191/"; 
      };

      serverAliases = [
        "www.jackett.${local_domain}"
      ];
    };
  };


}
