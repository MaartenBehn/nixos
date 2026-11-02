{ inputs, ... }: {
  my.secrets.server = {
    "jellyfin_user_id" = {
      bitwarden = { name = "Jellyfin"; field = "user_id"; };
      owner = "audiomuse";           
    };

    "jellyfin_audiomuse_key" = { 
      bitwarden = { name = "Jellyfin"; field = "audiomuse_key"; };
      owner = "audiomuse"; 
    };
  };

  flake.modules.nixos.server = { pkgs, config, ... }: let
    audiomuse-pkgs = import inputs.nixpkgs-unstable {
          system = config.system_type;
          overlays = [ inputs.audiomuse.overlays.cpu ];
          config.allowUnsupportedSystem = true;
        }; 

    in {
    imports = [
      inputs.audiomuse.nixosModules.audiomuse-ai
    ];
        
    sops.templates."audiomuse.env" = {
      content = ''
        JELLYFIN_USER_ID=${config.sops.placeholder."jellyfin_user_id"}
        JELLYFIN_TOKEN=${config.sops.placeholder."jellyfin_audiomuse_key"}
      '';
      owner = "audiomuse";
    };

    users.groups.media.members = [ "audiomuse" ];

    services.audiomuse-ai = {
      enable = true;

      package = audiomuse-pkgs.audiomuse-ai;
      modelsPackage = audiomuse-pkgs.audiomuse-ai-models;

      port = 8000;
      host = "127.0.0.1";

      musicDir = "/media/music";

      workers.count = 1;

      environmentFile = config.sops.templates."audiomuse.env".path;

      extraEnvironment = {
        MEDIASERVER_TYPE = "jellyfin";
        JELLYFIN_URL = "http://127.0.0.1:8096";
        AUTH_ENABLED = "false"; 
        FLASK_BUILTIN_HTTPS = "false";
      };

      plugins = {
        enable = true;
        port = 8001;
      };
    };
    systemd.services.audiomuse-ai.serviceConfig.SupplementaryGroups = [ "media" ];

    web_services = {
      "audiomuse" = {
        domains = "local";
        root = {
          proxyPass = "http://127.0.0.1:8000/";
          proxyWebsockets = true;
        };
      };
    };
  };
}
