{ pkgs, pkgs-unstable, local_domain, ... }: 
let 
  valid_check = pkgs.writeShellScriptBin "valid_check" ''
    if [ ! -d "/srv/Lidarr" ]; then
      cd /srv 
      git clone https://github.com/Lidarr/Lidarr.git
      chown -R lidarr_build:lidarr_build /srv/Lidarr 
    fi
  '';

  update = pkgs.writeShellScriptBin "update" ''
    cd /srv/Lidarr 
    git checkout plugins
    git pull
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

  users.users.lidarr = {
    isNormalUser = true;
    group = "lidarr_build";
  };
  users.groups.lidarr_build = {};

  systemd.services.lidarr-plugins-valid = {
    path = with pkgs; [
      git
      valid_check
    ];
    script = "valid_check";
  };

  systemd.services.lidarr-plugins-update = {
    path = with pkgs; [
      git
      dotnet-sdk
      bash
      update
    ];
    script = "update";
    serviceConfig.User = "lidarr_build";
  };

  users.groups.media.members = [ "lidarr" ]; 

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
