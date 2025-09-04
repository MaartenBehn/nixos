{ pkgs, pkgs-unstable, domains, ... }: 
let 
  configFile = pkgs.writeText "config.json" (builtins.toJSON
  {
    trustedProxies = [ "127.0.0.1" ];
    userFiles = "/var/lib/actual-server/user-files";
    serverFiles = "/var/lib/actual-server/server-files";
  });
 
  actual-enable-banking = pkgs.writeShellScriptBin "actual-enable-banking" ''
    cd /srv/ 
    rm -rf actual/
    git clone https://github.com/realtwister/actual.git
    cd actual
    git checkout feature/enable-banking-integration

    yarn install
    yarn build:server
    yarn start:server --config ${configFile}
  '';

in {

  #systemd.services.actual-server = {
    #  path = [
    #  pkgs.actual-server
    #];
    #script = "actual-server --config ${configFile}";
    #wantedBy = [ "network-online.target" ];
    #after = [ "network.target" ];
  #};

  systemd.services.actual-server = {
    path = with pkgs; [
      nodejs
      yarn-berry
      git
      sh
    ];
    script = ''sh ${actual-enable-banking}'';
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
