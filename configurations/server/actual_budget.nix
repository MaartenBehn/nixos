{ pkgs, domains, ... }: 
let
  configFile = pkgs.writeText "config.json" (builtins.toJSON
  {
    trustedProxies = [ "127.0.0.1" ];
    userFiles = "/var/lib/actual-server/user-files";
    serverFiles = "/var/lib/actual-server/server-files";
  });

  src = pkgs.fetchFromGitHub {
      name = "actualbudget-actual-source_patch";
      owner = "realtwister";
      repo = "actual";
      rev = "5b13e2f1b48b519b03750ffc78fea79e2c3f1dd1";
      hash = "sha256-GfMXhLHzhkBxv0DfC/Ug6jWbraSxzq9Bad1SNi5TquU=";
    };    
  translations = pkgs.fetchFromGitHub {
    name = "actualbudget-translations-source";
    owner = "actualbudget";
    repo = "translations";
    # Note to updaters: this repo is not tagged, so just update this to the Git
    # tip at the time the update is performed.
    rev = "c1c2f298013ca3223e6cd6a4a4720bca5e8b8274";
    hash = "sha256-3dtdymdKfEzUIzButA3L88GrehO4EjCrd/gq0Y5bcuE=";
  };

  actual-enable-banking = pkgs.actual-server.overrideAttrs (old: {
    version = "git";
    src = src;
    srcs = [ src translations ];
    sourceRoot = "${src.name}/";
  });
in {

  systemd.services.actual-server = {
    path = with pkgs; [
      actual-enable-banking
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
