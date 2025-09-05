{ local_domain, ... }: {
  users.groups.media.members = [ "radarr" ];

  services.radarr = { 
    enable = true;
    openFirewall = false;
  };

  systemd.services.radarr.vpnConfinement = {
    enable = true;
    vpnNamespace = "mullvad";
  };

  vpnNamespaces.mullvad = {
    portMappings = [
      { 
        from = 7878;
        to = 7878;
      }
    ];
  };

  services.nginx.virtualHosts = {

    "radarr.${local_domain}" = {
      locations."/" = {
        proxyPass = "http://192.168.15.1:7878/"; 
      };

      serverAliases = [
        "www.radarr.${local_domain}"
      ];
    };
  };
}
