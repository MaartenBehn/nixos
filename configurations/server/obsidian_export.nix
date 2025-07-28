{ pkgs, domains, local_domain, ... }:
let 
  valid_check = name: pkgs.writeShellScriptBin "valid_check.sh" ''
    if [ -d "/srv/obsidian_export" ]; then
      echo "/srv/obsidian_export does exist."
    fi
  ''; 
in {
  imports = [
    ./nignx.nix
  ];

  users.users.obsidian_export = {
    isSystemUser = true;
    group = "nginx";
  };

  systemd.services.obsidian_export-valid = {
    path = with pkgs; [
      git
      valid_check
    ];
    script = "";
    #startAt = "hourly";  
    startAt = "daily";  
    wantedBy = [ "network-online.target" ];
    user = "obsidian_export";
  };
 
  systemd.services.obsidian_export-updater = {
    path = with pkgs; [
      bash
      rustup
      nodejs
      git
      gcc
    ];
    script = "cd /home/stroby/dev/obsidian_export/ && sh rebuild.sh";
    #startAt = "hourly";  
    startAt = "daily";  
    wantedBy = [ "network-online.target" ];
    user = "obsidian_export";
  };
  systemd.timers.obsidian_export-updater.timerConfig.RandomizedDelaySec = "15m";

  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "notes.${domain}"; 
    value = {
      enableACME = domain != local_domain;
      forceSSL = domain != local_domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8082/"; 
      };

      serverAliases = [
        "www.notes.${domain}"
      ];
    };
  }) (domains ++ [ local_domain ]));
}
