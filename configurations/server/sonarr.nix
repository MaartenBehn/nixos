{ local_domain, ... }: {
  users.groups.media.members = [ "sonarr" ];

  services.sonarr = { 
    enable = true;
    openFirewall = false;
  };

  systemd.services.sonarr.vpnConfinement = {
    enable = true;
    vpnNamespace = "mullvad";
  };

  vpnNamespaces.mullvad = {
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
