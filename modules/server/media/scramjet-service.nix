{
  flake.modules.nixos.core = { config, lib, pkgs, ... }: with lib; let
    cfg = config.services.scramjet;

    wasm-snip = pkgs.rustPlatform.buildRustPackage rec {
      pname = "wasm-snip";
      version = "0.4.0"; # Adjust if needed

      src = pkgs.fetchFromGitHub {
        owner = "r58playz";
        repo = "wasm-snip";
        rev = "master";
        hash = "sha256-oU2R7rHgf+uMymSwLXEaHXW9Agkemi3WcUuMrTy32uk=";
      };

      cargoLock = {
        lockFile = ./_wasm-snip-cargo.lock;
      };

      postPatch = ''
        cp ${./_wasm-snip-cargo.lock} Cargo.lock
      '';

      cargoHash = "sha256-zcJ57hw1ZiAdIa4rhpbJq1vtlKgEtViTiiG2a57t/3w=";
      doCheck = false;
    };

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

      nativeBuildInputs = with pkgs; [
        nodejs
        pnpm
        pnpmConfigHook
        cargo
        wasm-bindgen
        binaryen
        wasm-snip
        bash
      ];

      pnpmDeps = pkgs.pnpm.fetchDeps {
        inherit pname version src;
        fetcherVersion = 3;
        hash = "sha256-Psbbx0IgaLv42bhxJcwbSXkCzbL3SM/kFd686XkbdqM=";
      };

      buildPhase = ''
        runHook preBuild

        echo $PATH

        # Fake the rustup "+nightly" wrapper so build.sh works without rustup installed
        mkdir -p bin-wrappers
        cat << 'EOF' > bin-wrappers/cargo
        #!/usr/bin/env bash
        if [ "$1" = "+nightly" ]; then
        shift
        fi
        exec cargo "$@"
        EOF
        chmod +x bin-wrappers/cargo
        export PATH="$(pwd)/bin-wrappers:$PATH"

        export RELEASE=1

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
