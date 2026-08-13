{
  flake.modules.nixos.core = { config, lib, pkgs, ... }: with lib; let
    cfg = config.services.ultraviolet;

    ultraviolet-app = pkgs.stdenv.mkDerivation rec {
      pname = "ultraviolet-app";
      version = "46750821262cba54b4bd67b0fb096914daefee51";

      src = pkgs.fetchFromGitHub {
        owner = "titaniumnetwork-dev";
        repo = "Ultraviolet-App";
        rev = version;
        hash = "sha256-bQGRc8jsiX/Nn1Ol54YCXSD6qNieoDwVeBTazhSmlDM=";
      };

      nativeBuildInputs = [
        pkgs.nodejs
        pkgs.pnpm
        pkgs.pnpmConfigHook
        pkgs.makeBinaryWrapper
      ];

      pnpmDeps = pkgs.fetchPnpmDeps {
        inherit pname version src;
        pnpm = pkgs.pnpm;
        fetcherVersion = 3;
        hash = "sha256-RppQehtcpHwpeJ0nq5nnA/mDM844yvdbiCqzRLXyELQ=";
      };

      buildPhase = ''
        runHook preBuild
        pnpm build
        runHook postBuild
      '';

      # 2. Package built output + node_modules and create a runnable binary wrapper
      installPhase = ''
        runHook preInstall

        mkdir -p $out/share/ultraviolet
        cp -r . $out/share/ultraviolet

        # Create a wrapper executable so 'nix run' or a systemd service can start it directly
        mkdir -p $out/bin
        makeWrapper ${pkgs.nodejs}/bin/node $out/bin/ultraviolet-app \
        --add-flags "$out/share/ultraviolet/index.js" \
        --chdir "$out/share/ultraviolet"

        runHook postInstall
      '';    
    };
  in
    {
    options.services.ultraviolet = {
      enable = mkEnableOption "Ultraviolet Web Proxy Service";

      port = mkOption {
        type = types.port;
        default = 8080;
        description = "Port for the Ultraviolet service to listen on.";
      };

      bindAddress = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = "IP address for the Ultraviolet service to bind to.";
      };

      user = mkOption {
        type = types.str;
        default = "ultraviolet";
        description = "User account under which Ultraviolet runs.";
      };

      group = mkOption {
        type = types.str;
        default = "ultraviolet";
        description = "Group under which Ultraviolet runs.";
      };
    };

    config = mkIf cfg.enable {

      # Dedicated unprivileged user and group
      users.users = mkIf (cfg.user == "ultraviolet") {
        ultraviolet = {
          isSystemUser = true;
          group = cfg.group;
          description = "Ultraviolet Proxy service daemon";
        };
      };

      users.groups = mkIf (cfg.group == "ultraviolet") {
        ultraviolet = {};
      };

      # Systemd Service Unit
      systemd.services.ultraviolet = {
        description = "Ultraviolet Web Proxy Server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        environment = {
          PORT = toString cfg.port;
          HOST = cfg.bindAddress;
        };

        serviceConfig = {
          ExecStart = "${pkgs.nodejs}/bin/node ${ultraviolet-app}/share/ultraviolet/src/index.js";
          WorkingDirectory = "${ultraviolet-app}/share/ultraviolet";
          User = cfg.user;
          Group = cfg.group;
          Restart = "always";
          RestartSec = "5s";

          # Systemd Hardening & Security Isolation
          CapabilityBoundingSet = "";
          NoNewPrivileges = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          PrivateDevices = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectControlGroups = true;
          RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
          RestrictNamespaces = true;
          LockPersonality = true;
          MemoryDenyWriteExecute = false; # Node.js V8 requires JIT memory mapping
        };
      };
    };
  };
}
