{ local_domain, ... }: {
  users.groups.media.members = [ "whisparr" ];

  services.whisparr = { 
    enable = true;
    openFirewall = false;
    settings.server.port = 6969;
  };

  systemd.services.radarr.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };

  vpnNamespaces.wg = {
    portMappings = [
      { 
        from = 6969;
        to = 6969;
      }
    ];
  };

  services.nginx.virtualHosts = {

    "whisparr.${local_domain}" = {
      locations."/" = {
        proxyPass = "http://192.168.15.1:6969/"; 
      };

      serverAliases = [
        "www.whisparr.${local_domain}"
      ];
    };
  };
}
