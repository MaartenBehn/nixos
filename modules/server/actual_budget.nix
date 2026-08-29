{
  flake.modules.nixos.server = { pkgs, pkgs-unstable, lib, config, ... }: 
    let 
      actual_server_folder = "/var/lib/actual-server/";
      user_files = "user-files";
      server_files = "server-files";
      user_files_test = "${user_files}-test";
      server_files_test = "${server_files}-test";
      data_dir = "${actual_server_folder}data";

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

      actual_src = pkgs-unstable.fetchFromGitHub {
        name = "actualbudget-actual-source";
        owner = "MaartenBehn";
        repo = "actual";
        rev = "bd5f07529a039268d3c4183c2a7d7b38154508e9";
        hash = "sha256-WRsw5Y8wcq8ee3iuYhBlpLATsTQC+NX2lV3OlVtOjAQ=";
      };

      actual-server-master = pkgs-unstable.actual-server.overrideAttrs (old: {
        version = "fix_5";
        src = actual_src; 
        srcs = [
          actual_src
          old.passthru.translations          
        ];     
      });

      # Backup
      default_borg_settings = import ./_borg_settings.nix { inherit config; };

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
            value = default_borg_settings // {
              group = "actual";
              paths = path;
              repo = "ssh://Stroby@192.168.178.39/volume1/BackUp/asus_server/actual-server/${name}";
              startAt = "*-*-* 03:00";
            };
          }
          {
            name = "proxy_actual_server_${name}";
            value = default_borg_settings // {
              group = "actual";
              paths = path;
              repo = "ssh://root@138.199.203.38/backup/actual-server/${name}";
              startAt = "*-*-* 03:15";
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
          onFailure = [ "unit-status@%n.service" ];
          requires = [ "fritz_behns_vpn_check.service" ];
          after = [ "fritz_behns_vpn_check.service" ];
        };
      }) backup_names;

      # Joining all services
      systemd_services = builtins.listToAttrs ([ 
         {
          name = "actual-server";
          value = {
            environment = {
              ACTUAL_CONFIG_PATH = configFileTest;
              ACTUAL_DATA_DIR = data_dir;
              DEBUG = "*";
            };

            path = [ pkgs-unstable.actual-server ];
            script = "actual-server --config ${configFile}";
            wantedBy = [ "multi-user.target" ];
            wants = [ "network.target" ];
            after = [ "network.target" ];

            serviceConfig = {
              User = "actual";
            };
          };
        }
      ] ++ backup_jobs_systemd_services_config_names); 

    in {
      users.groups.actual = {};
      users.users.actual = {
        isNormalUser = true;
        group = "actual";
      };

      systemd.services = systemd_services;

      web_services."budget" = {
        domains = "public";
        root = {
          proxyPass = "http://127.0.0.1:5006/";
          proxyWebsockets = true;

          extraConfig = ''
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header Host $host;
          '';
        };
      };

      # Backups 
      services.borgbackup.jobs = backup_jobs;
    };
}
