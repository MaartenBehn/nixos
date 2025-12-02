{ pkgs, pkgs-unstable, local_domain, ... }: 
let 
  # Local build from plugins branch
plugin_branch = pkgs-unstable.lidarr.overrideAttrs (old: {
  version = "plugins"; # usually harmless to omit

  # scp ~/dev/Lidarr/_artifacts/linux-x64/net6.0/Lidarr.tar.gz asus:~/Downloads 
  src = /home/stroby/Downloads/Lidarr.tar.gz;
  });

in {

  imports = [
    ./slskd.nix
  ];

  users.groups.media.members = [ "lidarr" ];

  services.lidarr = { 
    enable = false;
    openFirewall = false;
    ##package = pkgs-unstable.lidarr;
    package = plugin_branch;
  };
  
  systemd.services.lidarr = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "mullvad";
    };

    # For youtube download plugin
    path = [
      pkgs.ffmpeg
    ];
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
  };
}
