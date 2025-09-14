{ pkgs, pkgs-unstable, domains, username, lib, ... }: 
let 
  actual_server_folder = "/var/lib/actual-server/";
  user_files = "user-files";
  server_files = "server-files";
  user_files_test = "${user_files}-test";
  server_files_test = "${server_files}-test";

  configFile = pkgs.writeText "config.json" (builtins.toJSON
  {
    trustedProxies = [ "127.0.0.1" ];
    userFiles = actual_server_folder + user_files;
    serverFiles = actual_server_folder + server_files;
  });

  configFileTest = pkgs.writeText "config.json" (builtins.toJSON
  {
    trustedProxies = [ "127.0.0.1" ];
    userFiles = actual_server_folder + user_files_test;
    serverFiles = actual_server_folder + server_files_test;
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

  # Backup
  backup_names = [ 
    user_files
    server_files
    user_files_test
    server_files_test
  ];

  backup_jobs = builtins.listToAttrs (lib.lists.flatten (builtins.map (name: 
    let path = actual_server_folder + name;
    in [
      {
        name = "fritz_behns_actual_server_${name}";
        value = {
          paths = path;
          encryption.mode = "none";
          environment.BORG_RSH = "ssh -i /home/${username}/.ssh/id_ed25519";
          repo = "ssh://Stroby@192.168.178.39/volume1/BackUp/asus_server/actual-server/${name}";
          compression = "auto,zstd";
          startAt = "daily";
          user = "stroby";
        };
      }
      {
        name = "proxy_actual_server_${name}";
        value = {
          paths = path;
          encryption.mode = "none";
          environment.BORG_RSH = "ssh -i /home/${username}/.ssh/id_ed25519";
          repo = "ssh://root@138.199.203.38/backup/actual-server/${name}";
          compression = "auto,zstd";
          startAt = "daily";
          user = "stroby";
        };
      }
    ]) backup_names));

  backup_jobs_systemd_services_config_names = builtins.map (name: {
      name = "borgbackup-job-fritz_behns_actual_server_${name}"; 
      value = {
        vpnConfinement = {
          enable = true;
          vpnNamespace = "fritz";
        };
      };
    }) backup_names;

  # Joining all services
  systemd_services = builtins.listToAttrs ([ 
    {
      name = "actual-server-init";
      value = {
        path = with pkgs; [
          nodejs
          yarn-berry
          git
          bash
          actual_enable_banking_init
        ];
        script = "actual_enable_banking_init";
      };
    }
    {
      name = "actual-server";
      value = {
        path = with pkgs; [
          yarn-berry
          bash
          actual_enable_banking
        ];
        script = "actual_enable_banking";
        wantedBy = [ "network-online.target" ];
        after = [ "network.target" ];
      };
    }
  ] ++ backup_jobs_systemd_services_config_names); 


in {
    #systemd.services.actual-server = {
    #  path = [
    #  pkgs.actual-server
    #];
    #script = "actual-server --config ${configFile}";
    #wantedBy = [ "network-online.target" ];
    #after = [ "network.target" ];
    #};

  includes = [ ./borg.nix ];

  systemd.services = systemd_services;

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

  # Backups 
  services.borgbackup.jobs = backup_jobs;
}
