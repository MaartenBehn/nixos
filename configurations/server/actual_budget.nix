{ pkgs, pkgs-unstable, domains, ... }: 
let 
  configFile = pkgs.writeText "config.json" (builtins.toJSON
  {
    trustedProxies = [ "127.0.0.1" ];
    userFiles = "/var/lib/actual-server/user-files";
    serverFiles = "/var/lib/actual-server/server-files";
  });

  configFileTest = pkgs.writeText "config.json" (builtins.toJSON
  {
    trustedProxies = [ "127.0.0.1" ];
    userFiles = "/var/lib/actual-server/user-files-test";
    serverFiles = "/var/lib/actual-server/server-files-test";
  });

  # https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/ac/actual-server/package.nix
  actual_enable_banking_init = pkgs.writeShellScriptBin "actual_enable_banking_init" ''
    cd /srv/ 
    rm -rf actual/
    git clone https://github.com/MaartenBehn/actual.git
    cd actual
    git checkout feature/enable-banking-integration
    chmod +x ./bin/package-browser
    chmod +x ./packages/desktop-client/bin/build-browser

    yarn install
    yarn build:server
  '';

  actual_enable_banking = pkgs.writeShellScriptBin "actual_enable_banking" ''
    cd /srv/actual
    export ACTUAL_CONFIG_PATH=${configFileTest} 
    yarn start:server
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

  systemd.services.actual-server-init = {
    path = with pkgs; [
      nodejs
      yarn-berry
      git
      bash
      actual_enable_banking_init
    ];
    script = "actual_enable_banking_init";
    serviceConfig.User = "obsidian_export";
  };

  systemd.services.actual-server = {
    path = with pkgs; [
      yarn-berry
      bash
      actual_enable_banking
    ];
    script = "actual_enable_banking";
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
