{
  flake.modules.nixos.cli-full = { config, ... }: {
    sops.secrets."borg_passphrase" = { owner = config.username; };
  };

  flake.modules.homeManager.cli-full = { pkgs, lib, ... }: 
    let
      backup_folder = "~/backups"; 

      repo_folder_to_name = repo_folder: builtins.replaceStrings ["/"] ["_"] repo_folder;
      make_repo = repo_folder: server_name: (if server_name == "fritz_behns" then 
        "ssh://Stroby@192.168.178.39/volume1/BackUp/asus_server/${repo_folder}" 
      else 
        "ssh://root@138.199.203.38/backup/${repo_folder}");

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
        "none_encryption/notes"
        "sparkyfitness"
        "none_encryption/sparkyfitness"
      ] ++ actual_folders;

      only_fritz_folders = [
        "study"
        "none_encryption/study"
        "immich"
        "none_encryption/immich"
        "nextcloud"
        "none_encryption/nextcloud"
        "ellie_minibot_music"
        "none_encryption/ellie_minibot_music"
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

      if [ "''${1:-}" = "-h" ] || [ "''${1:-}" = "--help" ] || [ $# -lt 2 ]; then
          echo "Usage: sudo borg-import-tar <OLD_REPO_PATH> <NEW_REPO_PATH>"
          echo ""
          echo "Example:"
          echo "  sudo borg-import-tar ssh://root@138.199.203.38/backup/notes /mnt/backups/notes-encrypted"
          exit 1
      fi

      OLD_REPO="$1"
      NEW_REPO="$2"
      SECRET_PATH="/run/secrets/borg_passphrase"

      BORG="${pkgs.borgbackup}/bin/borg"
      JQ="${pkgs.jq}/bin/jq"

      if [ ! -f "$SECRET_PATH" ]; then
          echo "Error: Passphrase secret file not found at $SECRET_PATH" >&2
          exit 1
      fi

      export BORG_PASSPHRASE="$(cat "$SECRET_PATH")"

      echo "=== Borg v1 Import ==="
      echo "Old Repo:    $OLD_REPO"
      echo "New Repo:    $NEW_REPO"
      echo "Secret Path: $SECRET_PATH"
      echo "----------------------------------------"

      echo "[1/3] Fetching list of archives from OLD repo..."
      OLD_ARCHIVES=$("$BORG" list --short "$OLD_REPO")

      echo "[2/3] Fetching list of existing archives in NEW repo..."
      NEW_ARCHIVES=$("$BORG" list --short "$NEW_REPO" 2>/dev/null || true)

      echo "[3/3] Streaming archives via Tar-Pipe..."
      for archive_name in $OLD_ARCHIVES; do

          # 1. Prüfen, ob Archiv im Ziel-Repo existiert und valide ist
          if echo "$NEW_ARCHIVES" | grep -qxF "$archive_name"; then
              echo "--> Checking integrity of existing archive: $archive_name"

              NFILES=$("$BORG" info --json "$NEW_REPO::$archive_name" 2>/dev/null | "$JQ" '.archives[0].stats.nfiles' 2>/dev/null || echo "0")

              if [ "$NFILES" -gt 0 ]; then
                  echo "    [VALID] $archive_name is intact ($NFILES files). Skipping."
                  continue
              else
                  echo "    [EMPTY/BROKEN] $archive_name has $NFILES files. Deleting..."
                  "$BORG" delete "$NEW_REPO::$archive_name" || true
              fi
          fi

          echo "--> Streaming archive: $archive_name"

          "$BORG" export-tar "$OLD_REPO::$archive_name" - | \
          "$BORG" import-tar "$NEW_REPO::$archive_name" -
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
