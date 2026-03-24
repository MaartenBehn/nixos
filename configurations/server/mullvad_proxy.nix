{ pkgs, ... }: 
let
  configFile = pkgs.writeText "nginx.conf" ''
error_log /dev/null crit;
access_log off;

events {}

http {
  server {
    listen 0.0.0.0:1111;

    location / {
      proxy_pass https://scenenzbs.com;
    }
  }
}  '';
in {
  users.users.mullvad_proxy = {
    isNormalUser = true;
    group = "mullvad_proxy";
  };
  users.groups.mullvad_proxy = {};

  systemd.services.mullvad_proxy = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "mullvad";
    };

    path = with pkgs; [
      nginx
    ];
    script = "nginx -c ${configFile} -g 'daemon off;'";
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
