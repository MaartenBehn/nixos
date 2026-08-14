{
  flake.modules.nixos.core = { config, lib, pkgs, ... }: with lib; let
    cfg = config.services.scramjet;

    scramjetPackage = pkgs.stdenv.mkDerivation rec {
      pname = "scramjet";
      version = "v2.0.67-alpha.2";

      src = pkgs.fetchFromGitHub {
        owner = "MercuryWorkshop";
        repo = "scramjet";
        rev = version;
        fetchSubmodules = true;
        hash = "sha256-oZeFxhoTfv5fj2IcWO/AG4UdrVroJXjWacflhF0ytdo="; 
      };

      nativeBuildInputs = [
        pkgs.nodejs
        pkgs.pnpmConfigHook
      ];

      pnpmDeps = pkgs.pnpm.fetchDeps {
        inherit pname version src;
        fetcherVersion = 3;
        hash = "";
      };

      buildPhase = ''
        runHook preBuild

        pnpm --filter ./packages/core rewriter:build
        pnpm --filter ./packages/core build

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out/lib/scramjet
        cp -r . $out/lib/scramjet

        runHook postInstall
      '';    
    };
  in {
    options.services.scramjet = {
      enable = mkEnableOption "Scramjet Web Proxy Service";

      package = mkOption {
        type = types.package;
        default = scramjetPackage;
        description = "The Scramjet package derivation to use.";
      };

      port = mkOption {
        type = types.port;
        default = 8080;
        description = "The port Scramjet should listen on.";
      };

      host = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "The host IP Scramjet should bind to.";
      };

      environment = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = "Extra environment variables to pass to the Scramjet service.";
      };
    };

    config = mkIf cfg.enable {
      systemd.services.scramjet = {
        description = "Scramjet Web Proxy Service";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        environment = {
          PORT = toString cfg.port;
          HOST = cfg.host;
        } // cfg.environment;

        serviceConfig = {
          ExecStart = "${pkgs.nodejs}/bin/node ${cfg.package}/lib/node_modules/scramjet/dist/index.js";

          Restart = "always";
          RestartSec = "5s";

          DynamicUser = true;           
          NoNewPrivileges = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          ProtectHostname = true;
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
          RestrictNamespaces = true;
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
        };
      };
    };
  };
}
