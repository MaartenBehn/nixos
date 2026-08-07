{
  flake.modules.nixos.core = { config, pkgs, lib, ... }:
    let
      cfg = config.services.wanderer;

      version = "v0.20.0";
      src = pkgs.fetchFromGitHub {
        owner = "open-wanderer";
        repo = "wanderer";
        rev = version;
        hash = "sha256-Z4oKOf8bLyoYqjsg/bWWc8GYai2ZUYISFBiu4AHGexY=";
      };

      wandererPkg = pkgs.buildNpmPackage {
        pname = "wanderer";
        version = version;
        src = src;
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

      wandererDbPkg = pkgs.buildGoModule {
        pname = "wanderer-db";
        version = version;
        src = src;
        sourceRoot = "${src.name}/db"; 
        vendorHash = null;
      };

    in {
      options.services.wanderer = {
        enable = lib.mkEnableOption "Wanderer Trail Database Service";

        port = lib.mkOption {
          type = lib.types.port;
          default = 3000;
          description = "Port Wanderer HTTP server listens on.";
        };

        pbPort = lib.mkOption {
          type = lib.types.port;
          default = 8091;
          description = "Port PocketBase listens on.";
        };

        origin = lib.mkOption {
          type = lib.types.str;
          default = "http://localhost:3000";
          description = "Canonical origin URL for CORS and frontend redirects.";
        };

        dataDir = lib.mkOption {
          type = lib.types.path;
          default = "/var/lib/wanderer";
          description = "State directory where PocketBase data and uploads are stored.";
        };

        meiliKeySopsField = lib.mkOption {
          type = lib.types.str;
          default = "meili_master_key";
          description = "Sops secret field containing the Meilisearch master key.";
        };

        pbEncryptionKeySopsField = lib.mkOption {
          type = lib.types.str;
          default = "wanderer_pb_encryption_key";
          description = "Sops secret field containing PocketBase encryption key.";
        };
      };

      config = lib.mkIf cfg.enable {
        sops.secrets."${cfg.meiliKeySopsField}" = { mode = "0444"; };
        sops.secrets."${cfg.pbEncryptionKeySopsField}" = { mode = "0444"; };

        sops.templates."wanderer.env" = {
          owner = "wanderer";
          group = "wanderer";
          content = ''
            MEILI_MASTER_KEY=${config.sops.placeholder."${cfg.meiliKeySopsField}"}
            POCKETBASE_ENCRYPTION_KEY=${config.sops.placeholder."${cfg.pbEncryptionKeySopsField}"}
          '';
        };

        services.meilisearch = {
          enable = true;
          listenAddress = "127.0.0.1";
          listenPort = 7700;
          masterKeyFile = config.sops.secrets."${cfg.meiliKeySopsField}".path;
        };

        users.users.wanderer = {
          isSystemUser = true;
          group = "wanderer";
          home = cfg.dataDir;
          createHome = true;
        };
        users.groups.wanderer = {};

        systemd.services.wanderer-db = {
          description = "Wanderer PocketBase Backend";
          after = [ "network.target" "meilisearch.service" "sops-nix.service" ];
          wants = [ "meilisearch.service" "sops-nix.service" ];
          wantedBy = [ "multi-user.target" ];

          environment = {
            MEILI_URL = "http://127.0.0.1:7700";
            ORIGIN = cfg.origin;
          };

          serviceConfig = {
            User = "wanderer";
            Group = "wanderer";
            EnvironmentFile = config.sops.templates."wanderer.env".path;
            ExecStart = "${wandererDbPkg}/bin/wanderer serve --http=127.0.0.1:${toString cfg.pbPort} --dir=${cfg.dataDir}/pb_data";
            Restart = "always";
            RestartSec = "5s";

            StateDirectory = "wanderer";
            ProtectSystem = "strict";
            ProtectHome = true;
            PrivateTmp = true;
            ReadWritePaths = [ cfg.dataDir ];
          };
        };

        systemd.services.wanderer = {
          description = "Wanderer Trail Database Web Engine";
          after = [ "network.target" "wanderer-db.service" ];
          requires = [ "wanderer-db.service" ];
          wantedBy = [ "multi-user.target" ];

          environment = {
            PORT = toString cfg.port;
            HOST = "127.0.0.1";
            ORIGIN = cfg.origin;
            BODY_SIZE_LIMIT = "Infinity";
            PUBLIC_POCKETBASE_URL = "http://127.0.0.1:${toString cfg.pbPort}";
            UPLOAD_FOLDER = "${cfg.dataDir}/uploads";
            MEILI_URL = "http://127.0.0.1:7700";
            NODE_ENV = "production";
          };

          serviceConfig = {
            User = "wanderer";
            Group = "wanderer";
            WorkingDirectory = "${wandererPkg}/share/wanderer";
            ExecStart = "${pkgs.nodejs_22}/bin/node build/index.js";
            Restart = "always";
            RestartSec = "5s";

            EnvironmentFile = config.sops.templates."wanderer.env".path;

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
