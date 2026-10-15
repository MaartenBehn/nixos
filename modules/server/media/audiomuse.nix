{ inputs, ... }: {
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

    sops.secrets."audiomuse/jellyfin_user_id" = { owner = "audiomuse"; };
    sops.secrets."audiomuse/jellyfin_token" = { owner = "audiomuse"; };
    
    sops.templates."audiomuse.env" = {
      content = ''
        JELLYFIN_USER_ID=${config.sops.placeholder."audiomuse/jellyfin_user_id"}
        JELLYFIN_TOKEN=${config.sops.placeholder."audiomuse/jellyfin_token"}
      '';
      owner = "audiomuse";
    };

    services.audiomuse-ai = {
      enable = true;

      package = audiomuse-pkgs.audiomuse-ai;
      modelsPackage = audiomuse-pkgs.audiomuse-ai-models;

      port = 8000;
      host = "127.0.0.1";

      musicDir = "/media/music";

      workers.count = 8;

      mediaServer.jellyfin = {
        enable = true;
        url = "http://127.0.0.1:8096";
        libaries = [ "Music" ];
      };

      auth.enable = false;

      environmentFile = config.sops.templates."audiomuse.env".path; 
    };

    #services.navidrome = {
    #  plugins = [
    #     audiomuse-pkgs.navidromePlugins.audiomuse-ai
    #  ];
    #};


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
