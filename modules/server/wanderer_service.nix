{
  flake.modules.nixos.core = { config, pkgs, lib, ... }:
    let
      cfg = config.services.wanderer;

      # Build Wanderer natively from source using npm
      wandererPkg = pkgs.stdenv.mkDerivation rec {
        pname = "wanderer";
        version = "v0.20.0";

        src = pkgs.fetchFromGitHub {
          owner = "open-wanderer";
          repo = "wanderer";
          rev = "main";
          # Leave dummy hash or run nix-prefetch-github to get precise hash
          hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        };

        nativeBuildInputs = [
          pkgs.nodejs_20
          pkgs.pnpm_9
        ];

        buildPhase = ''
          export HOME=$TMPDIR
          pnpm install --frozen-lockfile
          pnpm build
          '';

            installPhase = ''
          mkdir -p $out/share/wanderer
          cp -r build package.json node_modules $out/share/wanderer/
        '';
      };
    in
      {
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
        };
      };

      config = lib.mkIf cfg.enable {
        sops.secrets."${cfg.meiliKeySopsField}" = { owner = "meilisearch"; };

        sops.templates."wanderer_meili_env" = {
          owner = "wanderer";
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
          };

          serviceConfig = {
            User = "wanderer";
            Group = "wanderer";
            WorkingDirectory = "${wandererPkg}/share/wanderer";
            ExecStart = "${pkgs.nodejs_20}/bin/node build/index.js";
            Restart = "always";
            RestartSec = "5s";

            # EnvironmentFile if using secrets management
            EnvironmentFile = config.sops.secrets."wanderer_meili_env".path;

            # Hardening
            StateDirectory = "wanderer";
            ProtectSystem = "strict";
            ProtectHome = true;
            PrivateTmp = true;
            NoNewPrivileges = true;
          };
        };
      };
    };
}
