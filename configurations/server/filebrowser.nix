{ pkgs, ... }: {
  systemd.services.filebrowser = {
    path = with pkgs; [
      filebrowser
      getent
    ];
    script = "filebrowser --address 127.0.0.1 --database /home/stroby/filebrowser.db";
    wantedBy = [ "network-online.target" ];
		after = [ "network.target" ];
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.nginx.enable = true;
  services.nginx.virtualHosts = let
    SSL = {
      enableACME = true;
      forceSSL = true;
    }; in {
      "filebrowser.stroby.duckdns.org" = (SSL // {
        locations."/".proxyPass = "http://127.0.0.1:8080/";

        serverAliases = [
          "www.filebrowser.stroby.duckdns.org"
        ];
      });

    };
}


