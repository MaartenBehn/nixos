{
  flake.modules.nixos.server_base = { lib, pkgs, config, ... }: {

    services.cockpit = {
      enable = true;
      port = 9090;
      settings = {
        WebService = {
          AllowUnencrypted = true;
          Origins = lib.mkForce "https://health.${config.domains.local}";
        };
      };
      plugins = [ 
        pkgs.cockpit-podman
        pkgs.cockpit-machines
        pkgs.cockpit-files
        pkgs.cockpit-zfs
      ];
    };


    web_services."health" = {
      domains = "local";
      root = {
        proxyPass = "http://127.0.0.1:9090/";
        proxyWebsockets = true;
      };
    };

  };
}
