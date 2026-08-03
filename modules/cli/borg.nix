{
  flake.modules.nixos.cli-full = {
    sops.secrets."borg_passphrase" = { owner = "stroby"; };
  };

  flake.modules.homeManager.cli-full = { pkgs, lib, ... }: 
    let
      backup_folder = "~/backups"; 

      repo_folder_to_name = repo_folder: builtins.replaceStrings ["/"] ["_"] repo_folder;
      make_repo = repo_folder: server_name: (if server_name == "fritz_behns" then 
        "ssh://Stroby@192.168.178.39/volume1/BackUp/asus_server/${repo_folder}" 
      else 
        "ssh://root@138.199.203.38/backup/none_encryption/${repo_folder}");

      make_script_inner = repo_folder: server_name: folder: pkgs.writeShellScriptBin 
        "borg_mount_${server_name}_${repo_folder_to_name repo_folder}" 
        ''
          SECRET_PATH="/run/secrets/borg_passphrase"
          export BORG_PASSPHRASE="$(cat "$SECRET_PATH")"
          mkdir -p ${folder}
          uid=$(id -u)
          borgfs -o uid=$uid -p ${make_repo repo_folder server_name} ${folder}
        '';

      make_script = repo_folder: server_name: (make_script_inner repo_folder server_name 
        ("${backup_folder}/${server_name}/${repo_folder_to_name repo_folder}")); 

      actual_folders = builtins.map (name: "actual-server/${name}") [
        "user-files"
        "server-files"
        "user-files-test"
        "server-files-test"
      ];

      both_folders = [
        "notes"
      ] ++ actual_folders;

      only_fritz_folders = [
        "study"
        "immich"
        "nextcloud"
        "ellie_minibot_music"
      ];

      servers = [
        "fritz_behns"
        "proxy"
      ];

      scripts = lib.lists.flatten (
        builtins.map (repo_folder: 
          builtins.map (server_name: 
            make_script repo_folder server_name
          ) servers
        ) both_folders
      ) ++ builtins.map (repo_folder: 
          make_script repo_folder "fritz_behns"
        ) only_fritz_folders;

      borg_import = pkgs.writeShellScriptBin "borg-import" ''
        set -eu

        # Usage helper
        if [ "''${1:-}" = "-h" ] || [ "''${1:-}" = "--help" ] || [ $# -lt 2 ]; then
            echo "Usage: sudo borg-import <OLD_REPO_PATH> <NEW_REPO_PATH>"
            echo ""
            echo "Example:"
            echo "  sudo borg-import /mnt/backups/old-none /mnt/backups/new-encrypted"
            exit 1
        fi

        OLD_REPO="$1"
        NEW_REPO="$2"
        SECRET_PATH="/run/secrets/borg_passphrase"
        MOUNT_POINT="/tmp/borg-import-mount-$$"

        # Path safety for binaries in Nix sandbox
        BORG="${pkgs.borgbackup}/bin/borg"
        BORGFS="${pkgs.borgbackup}/bin/borgfs"
        MOUNTPOINT="${pkgs.util-linux}/bin/mountpoint"
        BASENAME="${pkgs.coreutils}/bin/basename"

        if [ ! -f "$SECRET_PATH" ]; then
            echo "Error: Passphrase secret file not found at $SECRET_PATH" >&2
            exit 1
        fi

        export BORG_PASSPHRASE="$(cat "$SECRET_PATH")"

        cleanup() {
            echo "Cleaning up mount point..."
            if "$MOUNTPOINT" -q "$MOUNT_POINT" 2>/dev/null; then
                "$BORG" umount "$MOUNT_POINT" || true
            fi
            if [ -d "$MOUNT_POINT" ]; then
                rmdir "$MOUNT_POINT" || true
            fi
        }
        trap cleanup EXIT INT TERM

        echo "=== Borg v1 Archive Migration Script ==="
        echo "Old Repo:    $OLD_REPO"
        echo "New Repo:    $NEW_REPO"
        echo "Secret Path: $SECRET_PATH"
        echo "----------------------------------------"

        mkdir -p "$MOUNT_POINT"

        echo "[1/3] Mounting old repository with root access..."
        # -o allow_other ensures root can read all files regardless of internal archive ownership
        "$BORGFS" -o allow_other -p "$OLD_REPO" "$MOUNT_POINT"

        echo "[2/3] Fetching list of existing archives in destination repo..."
        EXISTING_ARCHIVES=$("$BORG" list --short "$NEW_REPO" 2>/dev/null || true)

        echo "[3/3] Transferring archives to new encrypted repository..."
        for archive_path in "$MOUNT_POINT"/*; do
            [ -e "$archive_path" ] || continue

            archive_name=$("$BASENAME" "$archive_path")

            # Check if archive exists and verify it isn't an empty 0-file placeholder
            if echo "$EXISTING_ARCHIVES" | grep -qxF "$archive_name"; then
                echo "--> Checking integrity of existing archive: $archive_name"

                # Get JSON info to verify file count > 0
                NFILES=$("$BORG" info --json "$NEW_REPO::$archive_name" 2>/dev/null | ${pkgs.jq}/bin/jq '.archives[0].stats.nfiles' 2>/dev/null || echo "0")

                if [ "$NFILES" -gt 0 ]; then
                    echo "    [VALID] $archive_name is intact ($NFILES files). Skipping."
                    continue
                else
                    echo "    [EMPTY/BROKEN] $archive_name has $NFILES files. Deleting empty archive..."
                    "$BORG" delete "$NEW_REPO::$archive_name" || true
                fi
            fi

            echo "--> Importing archive: $archive_name"

            # --exit-on-warning stops creation if permission errors happen
            "$BORG" create \
                --stats \
                --progress \
                --exit-on-warning \
                "$NEW_REPO::$archive_name" \
                "$archive_path"
        done

        echo "Migration completed successfully!"
      '';
    in {
 

      home.packages = (with pkgs; [
        borgbackup
        borg_import
      ] ++ scripts);
    };
}
