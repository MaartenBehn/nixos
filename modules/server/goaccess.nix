{
  flake.modules.nixos.server = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.goaccess ];

    systemd.services.goaccess = {
      description = "GoAccess Real-time Web Log Analyzer";
      after = [ "network.target" "nginx.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.goaccess}/bin/goaccess /var/log/nginx/access.log \
          -o /var/lib/goaccess/index.html \
          --log-format='%v:%^ %h %^[%d:%t %^] "%r" %s %b "%R" "%u"' \
          --date-format='%d/%b/%Y' \
          --time-format='%H:%M:%S' \
          --real-time-html \
          --ws-url=ws://stats.local:80/goaccess-ws \
          --port=7890
        '';
        Restart = "always";
        RestartSec = "5s";
        StateDirectory = "goaccess";
        User = "root"; # Needed to access Nginx access logs
      };
    };

    services.nginx.appendHttpConfig = ''
      log_format vhost_combined '$host:$server_port $remote_addr - $remote_user [$time_local] '
                                '"$request" $status $body_bytes_sent '
                                '"$http_referer" "$http_user_agent"';

      access_log /var/log/nginx/access.log vhost_combined;
    '';

    web_services.stats = {
      domains = "local";

      root = {
        alias = "/var/lib/goaccess/";
        index = "index.html";
      };

      locations = {
        "/goaccess-ws" = {
          proxyPass = "http://127.0.0.1:7890";
          extraConfig = ''
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "Upgrade";
          '';
        };
      };
    };
  };
}
