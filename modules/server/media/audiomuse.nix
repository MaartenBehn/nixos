{ inputs, ... }: {
  flake.modules.nixos.server = { pkgs, config, ... }: let
    audiomuse-pkgs = import inputs.nixpkgs-unstable {
          system = config.system_type;
          overlays = [ inputs.audiomuse.overlays.cpu ];
        }; 

    in {
    imports = [
      inputs.audiomuse.nixosModules.audiomuse-ai
    ];

    services.audiomuse-ai = {
      enable = true;

      package = audiomuse-pkgs.audiomuse-ai-cpu;
      modelsPackage = audiomuse-pkgs.audiomuse-ai-models;

      port = 8055;
      host = "127.0.0.1";

      musicDir = "/media/music";

      workers.count = 8;
    };

    web_services = {
      "audiomuse" = {
        domains = "local";
        root = {
          proxyPass = "http://172.17.0.1:8055/";
          proxyWebsockets = true;
        };
      };
    };
  };
}
