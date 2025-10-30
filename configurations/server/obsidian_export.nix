{ pkgs, domains, local_domain, ... }:
let 
  valid_check = pkgs.writeShellScriptBin "valid_check" ''
    if [ ! -d "/srv/obsidian_export" ]; then
      cd /srv 
      git clone https://github.com/MaartenBehn/obsidian_export.git
      chown -R obsidian_export:nginx /srv/obsidian_export 
    fi
  '';
  init = pkgs.writeShellScriptBin "init" ''
    cd /srv/obsidian_export 
    git clone https://github.com/jackyzha0/quartz.git

    cd ..
    rustup default stable
    git pull
  '';
  update = pkgs.writeShellScriptBin "update" ''
    cd /srv/obsidian_export 

    export PATH=$PATH:''${CARGO_HOME:-~/.cargo}/bin
    export PATH=$PATH:''${RUSTUP_HOME:-~/.rustup}/toolchains/$RUSTC_VERSION-x86_64-unknown-linux-gnu/bin/

    cargo run 

    cd quartz
    npm i
    npx quartz build  
    ''; 

  website_root = "";
in {
  imports = [
    ./nignx.nix
  ];

  users.groups.notes.members = [ "obsidian_export" "stroby" ];

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
  };

  systemd.services.obsidian_export-init = {
    path = with pkgs; [
      git
      nodejs
      rustup
      init
    ];
    script = "init";
    serviceConfig.User = "obsidian_export";
  };
 
  systemd.services.obsidian_export-updater = {
    path = with pkgs; [
      bash
      rustup
      nodejs
      git
      gcc
      update
    ];
    script = "update";
    startAt = "Sat 03:45";  
    wantedBy = [ "network-online.target" ];
    serviceConfig.User = "obsidian_export";
  };

  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "notes.${domain}"; 
    value = {
      enableACME = domain != local_domain;
      forceSSL = domain != local_domain;
      locations."/" = {
        root = "/srv/obsidian_export/quartz/public";
        extraConfig = '' 
          try_files $uri $uri.html /index.html =404;
        '';
      };

      serverAliases = [
        "www.notes.${domain}"
      ];
    };
  }) (domains ++ [ local_domain ]));
}
