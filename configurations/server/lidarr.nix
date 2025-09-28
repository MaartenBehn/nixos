{ pkgs-unstable, local_domain, ... }: 
let

plugin_branch = pkgs-unstable.lidarr.overrideAttrs (old: {
  version = "plugins"; # usually harmless to omit
  src = /home/stroby/Downloads/Lidarr.tar.gz
  });

in {
  users.groups.media.members = [ "lidarr" ];

  services.lidarr = { 
    enable = true;
    openFirewall = false;
    ##package = pkgs-unstable.lidarr;
    package = plugin_branch;
  };

  systemd.services.lidarr.vpnConfinement = {
    enable = true;
    vpnNamespace = "mullvad";
  };

  vpnNamespaces.mullvad = {
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

    "lidarr_fix.${local_domain}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8686/"; 
      };

      serverAliases = [
        "www.lidarr_fix.${local_domain}"
      ];
    };
  };
}
