{ pkgs, ... }: 
let
  configFile = pkgs.writeText "Caddyfile" ''
    :1111 {
      reverse_proxy https://scenenzbs.com
    }
  '';
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

    path = [ pkgs.caddy ];

    script = ''
      caddy run --config ${configFile} --adapter caddyfile
    '';

    serviceConfig = {
      User = "mullvad_proxy";
    };

    wantedBy = [ "multi-user.target" ];
  };

  vpnNamespaces.mullvad = {
    portMappings = [
      { 
        from = 1111;
        to = 1111;
      }
    ];
  };

  web_services."scenenzbs" = {
    domains = "local";
    loc = {
      proxyPass = "http://192.168.15.1:1111/"; 
    };
  };

}
