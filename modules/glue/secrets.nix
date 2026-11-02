{ config, lib, ... }: let 
  global_config = config;

  options = lib.types.submodule ({ name, ... }: {
    options = {
      bitwarden = {
        name = lib.mkOption {
          type = lib.types.str;
          default = name;
        };

        field = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
        }; 
      };

      description = lib.mkOption {
        type = lib.types.str;
        default = name;
      };

      owner = lib.mkOption {
        type = lib.types.str;
        default = "root";
      };

      path = lib.mkOption {
        type = lib.types.str;
        default = "/run/secrets/${name}";
      };

      mode = lib.mkOption {
        type = lib.types.str;
        default = "0400";
      }; 

    };
  });

in {
  options.my.secrets = lib.mkOption {
    type = lib.types.attrsOf (lib.types.attrsOf options);
    default = {};  
  };

  config.flake.modules.nixos.core = { lib, pkgs, config, ... }: {

    options.my.secrets = lib.mkOption {
      type = lib.types.attrsOf options; 
    };

    config = {
      my.secrets = lib.mergeAttrsList 
        (builtins.map (name: global_config.my.secrets.${name} or {}) global_config.hosts.${config.host}.modules);

      sops.secrets = lib.mapAttrs (name: value: { 
        inherit (value) owner;
        inherit (value) path;
        inherit (value) mode;
        sopsFile = ../../.sops.secretspec.yaml;
      }) config.my.secrets;

      environment.systemPackages = let

        all_secrets = lib.mergeAttrsList (lib.attrValues global_config.my.secrets);

        secretspec_secrets = {
          project = {
            name = "nixos";
            revision = "1.0";
          };

          profiles.default = lib.mapAttrs (name: value: {
            inherit (value) description;
            required = true;
            ref = {
              item = value.bitwarden.name; 
            } // lib.optionalAttrs (value.bitwarden.field != null) {
                field = value.bitwarden.field;
              };

          }) all_secrets;
        };

        secretspec_config = (pkgs.formats.toml { }).generate "secretspec.toml" secretspec_secrets;

      in [(pkgs.writeShellScriptBin "secrets-build" ''
          set -euo pipefail

          SOPS_TARGET_FILE="''${1:-.sops.secretspec.yaml}"
          TMP_JSON=$(mktemp --suffix=.json)

          cd ~/nixos
          cleanup() {
            cd -
            rm -f "$TMP_JSON"
          }
          trap cleanup EXIT

          echo "==> Syncing bitwarden"
          bw sync

          echo "==> Fetching secrets"
          if ! secretspec export --file ${secretspec_config} --format json > "$TMP_JSON"; then
            echo "Error: Failed to export secrets from secretspec." >&2
            exit 1
          fi

          if [ ! -s "$TMP_JSON" ]; then
            echo "Error: Received empty output from secretspec." >&2
            exit 1
          fi

          echo "==> Writing secrets"

          sops --encrypt \
          --input-type json \
          --output-type yaml \
          "$TMP_JSON" > "$SOPS_TARGET_FILE"

          chmod 600 "$SOPS_TARGET_FILE"
          echo "==> Done"
          '')
      ];
    };
  };
}
