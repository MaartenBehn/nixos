let 
  mkDownloader = pkgs: pkgs.writeShellApplication {
    name = "asstr-downloader";

    runtimeInputs = with pkgs; [
      curl
      gnugrep
      coreutils
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

      echo "=== Processing HTML Index for Download Targets ==="

      # 1. Fetch directory index structure and extract target file relative paths
      # Excludes .zip, .ZIP, and html files
      mapfile -t ALL_FILES < <(
      curl -sSL "$BASE_URL" | \
      grep -oP 'href="\K[^"]+' | \
      grep -vE '\.zip$|\.ZIP$|index\.html|^\?|^/' || true
      )

      echo "Found ''${#ALL_FILES[@]} potential items."

      # 2. Loop through each file path
      for REL_PATH in "''${ALL_FILES[@]}"; do
      # Skip directory links ending with a slash
      if [[ "$REL_PATH" == */ ]]; then
      continue
      fi

      FILE_URL="''${BASE_URL}''${REL_PATH}"
      LOCAL_PATH="''${DEST_DIR}/''${REL_PATH}"
      LOCAL_DIR=$(dirname "$LOCAL_PATH")

      # Step A: Skip if already logged as failed
      if grep -qFx "$FILE_URL" "$FAILED_LOG"; then
      echo "[SKIPPED - FAILED PREVIOUSLY] $REL_PATH"
      continue
      fi

      # Step B: Skip if already successfully downloaded (and non-empty)
      if [[ -s "$LOCAL_PATH" ]]; then
      echo "[SKIPPED - EXISTS] $REL_PATH"
      continue
      fi

      # Ensure destination directory exists locally
      mkdir -p "$LOCAL_DIR"

      echo -n "[DOWNLOADING] $REL_PATH ... "

      # Step C: Attempt download via curl
      if curl --fail --silent --show-error --location --output "$LOCAL_PATH" "$FILE_URL"; then
      echo "OK"
      else
      echo "FAILED"
      # Log failed URL if not already present
      echo "$FILE_URL" >> "$FAILED_LOG"
      # Clean up incomplete zero-byte download if created
      rm -f "$LOCAL_PATH"
      fi

      # Polite rate limiting delay
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
