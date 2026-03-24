{ pkgs, ... }: 
let
  configFile = pkgs.writeText "nginx.conf" ''
events {}

http {
    server {
        listen 0.0.0.0:1111;
        location / {
            proxy_pass https://scenenzbs.com;
        }
    }
}
  '';
in {
  users.users.mullvad_proxy = {
    isNormalUser = true;
    group = "mullvad_proxy";
  };

  systemd.services.mullvad_proxy = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "mullvad";
    };

    path = with pkgs; [
      nignx
    ];
    script = "nignx -c ${configFile} -g 'daemon off;'";
    wantedBy = [ "network-online.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      User = "mullvad_proxy";
    };
  };

  web_services."scenenzbs" = {
    domains = "local";
    loc = {
      proxyPass = "http://192.168.15.1:1111/"; 
    };
  };

}
