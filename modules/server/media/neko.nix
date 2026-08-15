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
        # bind on all interfaces so it's reachable both from your LAN and from inside the netns
      '';
    };

    networking.firewall.allowedTCPPorts = [ 3478 ];
    networking.firewall.allowedUDPPorts = [ 3478 ];
    networking.firewall.allowedUDPPortRanges = [
      { from = 49152; to = 49252; }
    ];

    
    # --- Neko: still confined to Mullvad netns, connects OUT to coturn on the host ---
    virtualisation.oci-containers.containers.neko = {
      image = "m1k1o/neko:firefox";
      autoStart = true;
      environment = {
        NEKO_DESKTOP_SCREEN = "1920x1080@30";
        NEKO_MEMBER_PROVIDER = "noauth";
        NEKO_WEBRTC_EPR = "52000-52100";
        NEKO_WEBRTC_ICELITE = "1";
        NEKO_SERVER_BIND = "192.168.15.1:8044";
        NEKO_SERVER_PROXY = "true";
        # Point clients at the host's real, reachable IP for the TURN relay.
        # Replace with whatever address your Neko clients can actually route to.
        NEKO_WEBRTC_ICESERVERS_FRONTEND = builtins.toJSON [
          {
            urls = [ "turn:neko.stroby.org/turn/" ];
            username = "nekouser";
            credential = "nekopass";
          }
        ];
      };
      #environmentFiles = [ config.sops.secrets.neko-env.path ];
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
      domains = "all";
      root = {
        proxyPass = "http://192.168.15.1:8044/";
        proxyWebsockets = true;
      };

      locations."/turn/" = {
        proxyPass = "http://127.0.0.1:3478/"; 
        proxyWebsockets = true;
      };
    };
  };
}
