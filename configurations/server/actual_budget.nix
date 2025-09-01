{ pkgs, local_domain, domains, ... }: 
let
  configFile = builtins.toJSON(
  {
    trustedProxies = [ "127.0.0.1" ];
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
      enableACME = domain != local_domain;
      forceSSL = domain != local_domain;

      locations."/" = {
        proxyPass = "http://127.0.0.1:5006/";
        proxyWebsockets = true;
      };

      serverAliases = [
        "www.budget.${domain}"
      ];
    };
  }) (domains ++ [ local_domain ]));
}
