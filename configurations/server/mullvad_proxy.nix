{ pkgs, ... }: 
let
  caddyWithPlugins = pkgs.caddy.withPlugins {
    plugins = [
      "github.com/caddyserver/replace-response@v0.0.0-20250618171559-80962887e4c6"
    ];
    hash = "sha256-VvUK813XSf7itorzjJO5CfDl482M0kDbuvbAec/BsuI=";
  };

  configFile = pkgs.writeText "Caddyfile" ''
    :1111 {
      route {
        reverse_proxy https://scenenzbs.com {
          header_up Host scenenzbs.com
          header_down Location scenenzbs.local
        }
      }

      replace_response scenenzbs.com scenenzbs.local
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

    path = [ caddyWithPlugins ];

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
