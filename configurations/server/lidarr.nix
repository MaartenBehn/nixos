{ pkgs, pkgs-unstable, local_domain, ... }: 
let 
  # Local build from plugins branch
  plugin_branch = pkgs-unstable.lidarr.overrideAttrs (old: {
    version = "plugins"; # usually harmless to omit

    # git clone git@github.com:Lidarr/Lidarr.git
    # cd Lidarr 
    # git checkout plugins
    # nix-shell -p dotnet-sdk yarn --command "sh build.sh -f linux-x64 --all"
    # mkdir lidarr-linux-x64
    # cp -R _output/net8.0/linux-x64/* lidarr-linux-x64
    # cp -R _output/UI lidarr-linux-x64
    # compress lidarr-linux-x64
    # scp lidarr-linux-x64.tar.gz asus:Downloads
    src = /home/stroby/Downloads/lidarr-linux-x64.tar.gz;
  });

in {

  imports = [
    ./slskd.nix
  ];
 
  users.groups.media.members = [ "lidarr" ]; 

  services.lidarr = { 
    enable = true;
    openFirewall = false;
    package = pkgs.lidarr;
    #package = plugin_branch;
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
