{ config, lib, ... }: let
  cfg = config.services.casual-sheets;

  mkCasualSheets = pkgs: pkgs.buildNpmPackage rec {
    pname = "casual-sheets";
    version = "0.9.0"; # Adjust to match upstream release tag or commit

    src = pkgs.fetchFromGitHub {
      owner = "CasualOffice";
      repo = "sheets";
      rev = "v${version}";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Replace with actual source hash on first build
    };

    npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Replace with actual npm deps hash on first build

    npmBuildScript = "build";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/casual-sheets
      cp -r dist server.js package.json node_modules $out/share/casual-sheets/
      runHook postInstall
    '';
  };
in
{
  config = {
    perSystem = { pkgs, ... }: {
      packages = {
        casualsheets = (mkCasualSheets pkgs);
      };
    };

    flake.modules.nixos.server = { pkgs, ... }: {
      options.services.casual-sheets = {
        enable = lib.mkEnableOption "Casual Sheets self-hosted web spreadsheet server";

        package = lib.mkOption {
          type = lib.types.package;
          default = (mkCasualSheets pkgs);
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 3000;
        };

        host = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
        };
      };

      config = lib.mkIf cfg.enable {
      systemd.services.casual-sheets = {
        description = "Casual Sheets Web Spreadsheet Daemon";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";
          DynamicUser = true;
          User = "casual-sheets";
          Group = "casual-sheets";

          # Automatically creates and manages /var/lib/casual-sheets with secure permissions
          StateDirectory = "casual-sheets";
          WorkingDirectory = "/var/lib/casual-sheets";

          Environment = [
            "PORT=" + toString cfg.port
            "HOST=" + cfg.host
            "NODE_ENV=production"
            "CASUAL_STORAGE=local"
            "CASUAL_LOCAL_PATH=/var/lib/casual-sheets/workbooks"
            ];

          ExecStart = "${pkgs.nodejs}/bin/node ${cfg.package}/share/casual-sheets/server.js";

          Restart = "on-failure";
          RestartSec = "5s";

          # Modern systemd hardening parameters
          ProtectSystem = "strict";
          ProtectHome = true;
          NoNewPrivileges = true;
          PrivateTmp = true;
        };
      };

      networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
    };
};
  }


/*
  { inputs, lib, config, ... }: let 
  mkNixvim = system: pkgs: inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
      inherit pkgs;
      module = config.nixvimConfig; 
    };

  in {
  options.nixvimConfig = lib.mkOption {
    type = lib.types.deferredModule;
    default = { };
  };

  config = {
    perSystem = { system, pkgs, ... }: {
      packages = {
        nvim = (mkNixvim system pkgs);
      };
    };

    flake.modules.nixos.cli-full = { config, ... }: {
      sops.secrets."avante_nvim/gemini_api_key" = { owner = config.username; };
    };

    flake.modules.homeManager.cli = { system, pkgs, ... }: {
      home.packages = with pkgs; [
        (mkNixvim system pkgs)
        xclip
        lazygit
        lldb
        nodePackages.prettier
        terraform
        cargo
        rustc
        shader-slang
        typst
      ];

      home.sessionVariables = {
        EDITOR = "nvim";
      };
    };
  };
}
*/
