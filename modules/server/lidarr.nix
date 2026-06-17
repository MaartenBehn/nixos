{
  flake.modules.nixos.server = { pkgs, pkgs-unstable, ... }: 
  let 
    # Local build from plugins branch
    plugin_branch = pkgs-unstable.lidarr.overrideAttrs (old: {
      version = "plugins"; # usually harmless to omit
          
      src = pkgs.fetchFromGitHub {
        owner = "Lidarr";
        repo = "Lidarr";
        rev = "e42a7ca4fd633e021d69da7daa0368b870b0282e";
        hash = "sha256-vjLoMU7Ow9rFFcZjCUvqoKZnrmg3TeB8Cqh1nSF8shM=";
      };
    });
    # https://github.com/blampe/hearring-aid/blob/main/docs/self-hosted-mirror-setup.md#101-configure-tubifarry-plugin-in-lidarr

    # Local build from plugins branch
    latest = pkgs.lidarr.overrideAttrs (old: {
      version = "v3.1.0.4875";
    });

  in {

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
  };
}
