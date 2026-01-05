{ pkgs, pkgs-unstable, local_domain, ... }: 
let 
  # Local build from plugins branch
  plugin_branch = pkgs-unstable.lidarr.overrideAttrs (old: {
    version = "plugins"; # usually harmless to omit

    # git clone git@github.com:Lidarr/Lidarr.git
    # cd Lidarr 
    # git checkout plugins
    # uncomment other systems
    # nix-shell -p dotnet-sdk yarn --command "sh build.sh"
    # cd _artifacts/linux-x64/net8.0 
    # compress Lidarr
    # scp Lidarr.tar.gz asus:Downloads
    
    src = /home/stroby/Downloads/Lidarr.tar.gz;
  });
  # https://github.com/blampe/hearring-aid/blob/main/docs/self-hosted-mirror-setup.md#101-configure-tubifarry-plugin-in-lidarr

  # Local build from plugins branch
  latest = pkgs.lidarr.overrideAttrs (old: {
    version = "v3.1.0.4875";
  });

in {

  imports = [
    ./slskd.nix
  ];
 
  users.groups.media.members = [ "lidarr" ]; 

  services.lidarr = { 
    enable = true;
    openFirewall = false;
    #package = pkgs.lidarr;
    package = plugin_branch;
    # package = latest;
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
  
  web_services."lidarr" = {
    domains = "local";
    loc = {
      proxyPass = "http://192.168.15.1:8686/"; 
    };
  };
}
