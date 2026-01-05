{ local_domain, ... }: {
  users.groups.media.members = [ "whisparr" ];

  services.whisparr = { 
    enable = true;
    openFirewall = false;
  };

  systemd.services.whisparr.vpnConfinement = {
    enable = true;
    vpnNamespace = "mullvad";
  };

  vpnNamespaces.mullvad = {
    portMappings = [
      { 
        from = 6969;
        to = 6969;
      }
    ];
  };

  web_services."whisparr" = {
    domains = "local";
    loc = {
      proxyPass = "http://192.168.15.1:6969/"; 
    };
  };
}
