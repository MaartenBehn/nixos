{ local_domain, ... }: {
  users.groups.media.members = [ "lidarr" ];

  services.lidarr = { 
    enable = true;
    openFirewall = false;
  };

  systemd.services.lidarr.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };

  vpnNamespaces.wg = {
    portMappings = [
      { 
        from = 8686;
        to = 8686;
      }
    ];
  };

  services.nginx.virtualHosts = {

    "lidarr.${local_domain}" = {
      locations."/" = {
        proxyPass = "http://192.168.15.1:8686/"; 
      };

      serverAliases = [
        "www.lidarr.${local_domain}"
      ];
    };
  };
}
