{ inputs, ... }: {
  flake.modules.nixos.server = { pkgs, config, ... }: {
    imports = [
      inputs.audiomuse.nixosModules.audiomuse-ai
    ];

    overlays = [
      inputs.audiomuse.overlays.cpu
    ];

    services.audiomuse-ai = {
      enable = true;

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
