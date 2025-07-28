{ pkgs, domains, local_domain, ... }:
let 
  valid_check = pkgs.writeShellScriptBin "valid_check" ''
    if [ ! -d "/srv/obsidian_export" ]; then
      cd /srv 
      git clone --recurse-submodules -j8 https://github.com/MaartenBehn/obsidian_export.git
      chown -R obsidian_export:nginx /srv/obsidian_export
    else 
      echo "/srv/obsidian_export found." 
    fi
  ''; 
in {
  imports = [
    ./nignx.nix
  ];

  users.users.obsidian_export = {
    isNormalUser = true;
    group = "nginx";
  };

  systemd.services.obsidian_export-valid = {
    path = with pkgs; [
      git
      valid_check
    ];
    script = "valid_check";
    wantedBy = [ "network-online.target" ];
  };
 
  systemd.services.obsidian_export-updater = {
    path = with pkgs; [
      bash
      rustup
      nodejs
      git
      gcc
    ];
    script = "cd /srv/obsidian_export/ && sh rebuild.sh";
    #startAt = "hourly";  
    startAt = "daily";  
    wantedBy = [ "network-online.target" ];
    serviceConfig.User = "obsidian_export";
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
