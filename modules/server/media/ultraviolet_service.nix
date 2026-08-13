{
  flake.modules.nixos.core = { config, lib, pkgs, ... }: with lib;

  let
    cfg = config.services.ultraviolet;

    # Build the Ultraviolet app directly from the official TitaniumNetwork repository
    ultraviolet-app = pkgs.buildNpmPackage rec {
      pname = "ultraviolet-app";
      version = "3.0.0"; # Pin or update to desired version/commit

      src = pkgs.fetchFromGitHub {
        owner = "titaniumnetwork-dev";
        repo = "Ultraviolet-App";
        rev = "v${version}";
        # Leave hash empty or set dummy hash first if changing version to let Nix output the correct SRI hash
        hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      };

      # npmDepsHash must match package-lock.json SRI hash from src repo
      npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

      dontNpmBuild = true;

      installPhase = ''
      runHook preInstall
      mkdir -p $out/share/ultraviolet
      cp -r . $out/share/ultraviolet
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
          ExecStart = "${pkgs.nodejs}/bin/node ${ultraviolet-app}/share/ultraviolet/index.js";
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
