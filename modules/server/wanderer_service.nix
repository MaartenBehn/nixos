{
  flake.modules.nixos.core = { config, pkgs, lib, ... }:
    let
      cfg = config.services.wanderer;

      wandererPkg = pkgs.buildNpmPackage rec {
        pname = "wanderer";
        version = "v0.20.0";

        src = pkgs.fetchFromGitHub {
          owner = "open-wanderer";
          repo = "wanderer";
          rev = "main"; # Recommendation: Use a tagged release commit or exact hash for reproducibility
          hash = "sha256-Z4oKOf8bLyoYqjsg/bWWc8GYai2ZUYISFBiu4AHGexY=";
        };

        sourceRoot = "${src.name}/web";

        npmDepsHash = "sha256-G+Ozwt8ir2StIFU/I4cMF77alNkW4sp28WJeTnBnBFk=";

        nodejs = pkgs.nodejs_22;

        installPhase = ''
          runHook preInstall

          mkdir -p $out/share/wanderer
          cp -r build package.json node_modules $out/share/wanderer/

          runHook postInstall
        '';
      };    
  in {
      options.services.wanderer = {
        enable = lib.mkEnableOption "Wanderer Trail Database Service";

        port = lib.mkOption {
          type = lib.types.port;
          default = 3000;
          description = "Port Wanderer HTTP server listens on.";
        };

        origin = lib.mkOption {
          type = lib.types.str;
          default = "http://localhost:3000";
          description = "Canonical origin URL for CORS and frontend redirects.";
        };

        dataDir = lib.mkOption {
          type = lib.types.path;
          default = "/var/lib/wanderer";
          description = "State directory where SQLite DB and uploads are stored.";
        };

        meiliKeySopsField = lib.mkOption {
          type = lib.types.str;
          default = "meili_master_key";
          description = "Sops secret field containing the Meilisearch master key.";
        };
      };

      config = lib.mkIf cfg.enable {
        sops.secrets."${cfg.meiliKeySopsField}" = {
          mode = "0444";
        };

        sops.templates."wanderer.env" = {
          owner = "wanderer";
          group = "wanderer";
          content = ''
            MEILI_MASTER_KEY=${config.sops.placeholder."${cfg.meiliKeySopsField}"}
          '';
        };

        services.meilisearch = {
          enable = true;
          listenAddress = "127.0.0.1";
          listenPort = 7700;
          masterKeyFile = config.sops.secrets."${cfg.meiliKeySopsField}".path;
        };

        systemd.services.meilisearch = {
          after = [ "sops-nix.service" ];
          wants = [ "sops-nix.service" ];
        };

        users.users.wanderer = {
          isSystemUser = true;
          group = "wanderer";
          home = cfg.dataDir;
          createHome = true;
        };
        users.groups.wanderer = {};

        systemd.services.wanderer = {
          description = "Wanderer Trail Database Engine";
          after = [ "network.target" "meilisearch.service" ];
          requires = [ "meilisearch.service" ];
          wantedBy = [ "multi-user.target" ];

          environment = {
            PORT = toString cfg.port;
            HOST = "127.0.0.1";
            ORIGIN = cfg.origin;
            DATABASE_PATH = "${cfg.dataDir}/wanderer.db";
            UPLOAD_DIR = "${cfg.dataDir}/uploads";
            MEILI_HOST = "http://127.0.0.1:7700";
            NODE_ENV = "production";
            NODE_OPTIONS = "--max-old-space-size=4096";
          };

          serviceConfig = {
            User = "wanderer";
            Group = "wanderer";
            WorkingDirectory = "${wandererPkg}/share/wanderer";
            ExecStart = "${pkgs.nodejs_20}/bin/node build/index.js";
            Restart = "always";
            RestartSec = "5s";

            EnvironmentFile = config.sops.templates."wanderer.env".path;

            # Hardening & State Permissions
            StateDirectory = "wanderer";
            StateDirectoryMode = "0750";
            ProtectSystem = "strict";
            ProtectHome = true;
            PrivateTmp = true;
            NoNewPrivileges = true;
            ReadWritePaths = [ cfg.dataDir ];
          };
        };
      };
    };
}
