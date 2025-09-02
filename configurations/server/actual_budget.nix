{ pkgs, domains, ... }: 
let
  configFile = pkgs.writeText "config.json" (builtins.toJSON
  {
    trustedProxies = [ "127.0.0.1" ];
    userFiles = "/var/lib/actual-server/user-files";
    serverFiles = "/var/lib/actual-server/server-files";
  });
in {
  environment.systemPackages = [
    pkgs.actual-server
  ];

  systemd.services.actual-server = {
    path = with pkgs; [
      actual-server
    ];
    script = "actual-server --config ${configFile}";
    wantedBy = [ "network-online.target" ];
		after = [ "network.target" ];
  };

  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "budget.${domain}"; 
    value = { 
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:5006/";
        proxyWebsockets = true;

        extraConfig = ''
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header Host $host;
        '';
      };

      serverAliases = [
        "www.budget.${domain}"
      ];
    };
  }) (domains));
}
