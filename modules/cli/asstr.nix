let 
  mkDownloader = pkgs: pkgs.writeShellApplication {
    name = "asstr-downloader";

    runtimeInputs = with pkgs; [
      curl
      gnugrep
      coreutils
      wget
    ];

    text = ''
      # Exit on unexpected errors or undefined variables
      set -euo pipefail

      # Configuration
      BASE_URL="https://www.asstr-mirror.org/files/Collections/"
      DEST_DIR="/media/stories/asstr"
      FAILED_LOG="$DEST_DIR/failed_uris.txt"
      WAIT_SEC=0.2

      # Ensure destination directory and log file exist
      mkdir -p "$DEST_DIR"
      touch "$FAILED_LOG"

      echo "=== Discovering Paths with Wget Spider ==="
      
      # Temporary file to store wget output
      WGET_SPIDER_LOG=$(mktemp)
      trap 'rm -f "$WGET_SPIDER_LOG"' EXIT

      # Discover all recursive paths without downloading the content
      wget --spider -r -np -nH --cut-dirs=1 \
        -R "*.zip,*.ZIP,index.html*" \
        -o "$WGET_SPIDER_LOG" \
        "$BASE_URL" || true
      
      echo "Found ''${#WGET_SPIDER_LOG[@]} uris."

      echo "=== Extracting target URLs ==="

      # Parse absolute URLs logged by wget spider
      mapfile -t ALL_URLS < <(
        grep -oP 'https://[^\s]+' "$WGET_SPIDER_LOG" | \
        grep -vE '\.zip$|\.ZIP$|index\.html|/\?|/$' | \
        sort -u || true
      )

      echo "Found ''${#ALL_URLS[@]} target files."

      # Loop through discovered URLs
      for FILE_URL in "''${ALL_URLS[@]}"; do
        # Derive relative local path from absolute URL
        REL_PATH="''${FILE_URL#"$BASE_URL"}"
        LOCAL_PATH="''${DEST_DIR}/''${REL_PATH}"
        LOCAL_DIR=$(dirname "$LOCAL_PATH")

        # Step A: Skip if logged in failed_uris.txt
        if grep -qFx "$FILE_URL" "$FAILED_LOG"; then
          echo "[SKIPPED - FAILED PREVIOUSLY] $REL_PATH"
          continue
        fi

        # Step B: Skip if already downloaded (and non-empty)
        if [[ -s "$LOCAL_PATH" ]]; then
          echo "[SKIPPED - EXISTS] $REL_PATH"
          continue
        fi

        # Ensure destination directory structure exists locally
        mkdir -p "$LOCAL_DIR"

        echo -n "[DOWNLOADING] $REL_PATH ... "

        # Step C: Download via curl
        if curl --fail --silent --show-error --location --output "$LOCAL_PATH" "$FILE_URL"; then
          echo "OK"
        else
          echo "FAILED"
          # Log failed URL to master skip log
          echo "$FILE_URL" >> "$FAILED_LOG"
          # Delete failed/incomplete download artifact
          rm -f "$LOCAL_PATH"
        fi

        sleep "$WAIT_SEC"
      done

      echo "=== Process Finished ==="
    '';
  };
in {
  perSystem = { system, pkgs, ... }: {
    packages = {
      asstr-downloader = mkDownloader pkgs;
    };
  };

  flake.modules.homeManager.cli = { pkgs, ... }: {
    home.packages = [
      (mkDownloader pkgs)
    ];
  };
}
