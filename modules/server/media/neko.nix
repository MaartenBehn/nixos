{
  flake.modules.nixos.server = { config, lib, pkgs, ... }: {
      virtualisation.oci-containers.containers.neko = {
        image = "m1k1o/neko:firefox";
        autoStart = true;

        environment = {
          NEKO_SCREEN = "1920x1080@30";
          NEKO_PASSWORD = "changeme-user-password";
          NEKO_PASSWORD_ADMIN = "changeme-admin-password";
          NEKO_EPR = "52000-52100"; # WebRTC UDP port range
          NEKO_ICELITE = "1";
        };

        extraOptions = [
          "--shm-size=2g"
          "--cap-add=SYS_ADMIN"
          "--network=host"
        ];
      };

    systemd.services."podman-neko".vpnConfinement = {
      enable = true;
      vpnNamespace = "mullvad";
    };

    vpnNamespaces.mullvad.portMappings = [
      { from = 8044; to = 8044; }
    ] ++ (lib.range 52000 52100 |> map (p: { from = p; to = p; protocol = "udp"; }));

    web_services."neko" = {
      domains = "local";
      root = {
        proxyPass = "http://192.168.15.1:8044/"; 
        proxyWebsockets = true;
      };
    };
  };
}
