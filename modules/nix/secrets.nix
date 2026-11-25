{ inputs, ... }: {
  
  

  flake.modules.nixos.core = { config, ... }: {
    imports = [ 
      inputs.sops-nix.nixosModules.sops
    ];

    sops.defaultSopsFile = ../../.sops.secretspec.yaml;
    sops.defaultSopsFormat = "yaml";

    sops.age.sshKeyPaths = [
      "/home/${config.username}/.ssh/id_ed25519"
    ];

    sops.age.keyFile = "/home/${config.username}/.config/sops/age/keys.txt";
  };

  flake.modules.homeManager.core = { pkgs, config, ... }: {
    home.packages = with pkgs; [
      secretspec
      bitwarden-cli
      bitwarden-desktop
      ssh-to-age

      (pkgs.writeShellScriptBin "secrets-bootstrap" ''
        set -euo pipefail

        HOST="''${1:-}"
        TARGET_DIR="''${2:-/etc/ssh}"

        if [ -z "$HOST" ]; then
          echo "Usage: secrets-bootstrap <hostname> [target_directory]"
          echo "Example: sudo secrets-bootstrap pigman /persistent/etc/ssh"
          exit 1
        fi

        echo "==> Ensuring Bitwarden CLI is logged in and synced"
        if ! bw unlock --check >/dev/null 2>&1; then
          echo "Please unlock Bitwarden:"
          BW_SESSION=$(bw unlock --raw)
          export BW_SESSION
        fi

        bw sync

        echo "==> Fetching SSH host ed25519 private key for $HOST from Bitwarden"
        ITEM_JSON=$(bw list items --search "$HOST" | jq -e 'map(select(.name == "'"$HOST"'" or .name == "Host - '"$HOST"'")) | first')

        if [ -z "$ITEM_JSON" ] || [ "$ITEM_JSON" = "null" ]; then
          echo "Error: Bitwarden item '$HOST' not found." >&2
          exit 1
        fi

        PRIV_KEY=$(echo "$ITEM_JSON" | jq -r '(.fields[]? | select(.name == "ssh_host_ed25519_key") | .value) // empty')
        PUB_KEY=$(echo "$ITEM_JSON" | jq -r '(.fields[]? | select(.name == "ssh_host_ed25519_key.pub") | .value) // empty')

        if [ -z "$PRIV_KEY" ]; then
          echo "Error: Field 'ssh_host_ed25519_key' not found in Bitwarden item '$HOST'." >&2
          exit 1
        fi

        mkdir -p "$TARGET_DIR"
        echo "$PRIV_KEY" > "$TARGET_DIR/ssh_host_ed25519_key"
        chmod 600 "$TARGET_DIR/ssh_host_ed25519_key"

        if [ -n "$PUB_KEY" ]; then
          echo "$PUB_KEY" > "$TARGET_DIR/ssh_host_ed25519_key.pub"
          chmod 644 "$TARGET_DIR/ssh_host_ed25519_key.pub"
        fi

        echo "==> SSH host key written to $TARGET_DIR/ssh_host_ed25519_key"
        echo "==> Age recipient:"
        ssh-to-age -i "$TARGET_DIR/ssh_host_ed25519_key.pub" 2>/dev/null || true
      '')
    ];

    home.file = {  
      "/home/${config.username}/.config/secretspec/config.toml" = { 
        force = true;
        text = ''
          [defaults]
          provider = "bw"
          profile = "default"
        ''; 
        executable = false; 
      };
    };
  };
}
