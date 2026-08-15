{
  flake.modules.nixos.server = { config, lib, pkgs, ... }: {
    services.coturn = {
      enable = true;
      realm = "neko.local";
      listening-port = 3478;
      min-port = 49152;
      max-port = 49252;
      no-cli = true;
      no-tls = true;
      no-dtls = true;
      extraConfig = ''
        user=nekouser:nekopass
      '';
    };

    networking.firewall.allowedTCPPorts = [ 3478 ];
    networking.firewall.allowedUDPPorts = [ 3478 ];
    networking.firewall.allowedUDPPortRanges = [
      { from = 49152; to = 49252; }
    ];

    virtualisation.oci-containers.containers.neko = {
      image = "m1k1o/neko:firefox";
      autoStart = true;
      environment = {
        NEKO_DESKTOP_SCREEN = "1920x1080@30";
        NEKO_MEMBER_PROVIDER = "noauth";
        NEKO_WEBRTC_EPR = "52000-52100";
        NEKO_WEBRTC_ICELITE = "0";
        NEKO_SERVER_BIND = "192.168.15.1:8044";
        NEKO_SERVER_PROXY = "true";
        NEKO_WEBRTC_ICESERVERS_FRONTEND = builtins.toJSON [
          { urls = [ "turn:192.168.0.117:3478" ]; username = "nekouser"; credential = "nekopass"; }
        ];
        NEKO_WEBRTC_ICESERVERS_BACKEND = builtins.toJSON [
          { urls = [ "turn:192.168.0.117:3478" ]; username = "nekouser"; credential = "nekopass"; }
        ];
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
