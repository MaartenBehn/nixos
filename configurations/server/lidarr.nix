{ pkgs, pkgs-unstable, local_domain, ... }: 
let 
  init = pkgs.writeShellScriptBin "init" ''
   if [ ! -d "/srv/obsidian_export" ]; then
      cd /srv 
      git clone https://github.com/Lidarr/Lidarr.git
    fi

    cd /srv/obsidian_export 
    git checkout plugins
    sh build.sh
  ''; 

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

  systemd.services.lidarr-plugins-init = {
    path = with pkgs; [
      git
      dotnet-sdk
      init
    ];
    script = "init";
    serviceConfig.User = "lidarr";
  };

  users.groups.media.members = [ "lidarr" ];

  users.users.lidarr = {
    isSystemUser = true;
    group = "lidarr";
  };
  users.groups.lidarr = {};


  services.lidarr = { 
    enable = false;
    openFirewall = false;
    #package = pkgs-unstable.lidarr;
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
