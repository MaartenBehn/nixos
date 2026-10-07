let 
  mkDownloader = pkgs: pkgs.writeTextFile {
    name = "asstr-downloader";
    destination = "/bin/asstr-downloader";
    executable = true;

    # Fish shell with required CLI tools in PATH
    text = ''
      #!${pkgs.fish}/bin/fish

      # Configuration
      set BASE_URL "https://www.asstr-mirror.org/files/Collections/"
      set DEST_DIR "/media/stories/asstr"
      set FAILED_LOG "$DEST_DIR/failed_uris.txt"
      set WAIT_SEC 0.2

      # Ensure destination directory and log file exist
      mkdir -p "$DEST_DIR"
      touch "$FAILED_LOG"

      echo "=== Discovering Paths with Wget Spider ==="
      
      # Create temporary file for wget output
      set WGET_SPIDER_LOG (mktemp)

      # Discover recursive paths without downloading content
      ${pkgs.wget}/bin/wget --spider -r -np -nH --cut-dirs=1 \
        -R "*.zip,*.ZIP,index.html*" \
        -o "$WGET_SPIDER_LOG" \
        "$BASE_URL"
      
      echo "Found "(count $WGET_SPIDER_LOG)" uris."

      echo "=== Extracting target URLs ==="

      # Extract absolute URLs into Fish list
      set ALL_URLS (${pkgs.gnugrep}/bin/grep -oP 'https://[^\s]+' "$WGET_SPIDER_LOG" | \
        ${pkgs.gnugrep}/bin/grep -vE '\.zip$|\.ZIP$|index\.html|/\?|/$' | \
        ${pkgs.coreutils}/bin/sort -u)

      # Clean up temp file
      rm -f "$WGET_SPIDER_LOG"

      echo "Found "(count $ALL_URLS)" target files."

      # Loop through discovered URLs
      for FILE_URL in $ALL_URLS
        # Derive relative local path by stripping BASE_URL prefix
        set REL_PATH (${pkgs.fish}/bin/string replace "$BASE_URL" "" "$FILE_URL")
        set LOCAL_PATH "$DEST_DIR/$REL_PATH"
        set LOCAL_DIR (${pkgs.coreutils}/bin/dirname "$LOCAL_PATH")

        # Step A: Skip if logged in failed_uris.txt
        if ${pkgs.gnugrep}/bin/grep -qFx "$FILE_URL" "$FAILED_LOG"
          echo "[SKIPPED - FAILED PREVIOUSLY] $REL_PATH"
          continue
        end

        # Step B: Skip if already downloaded (and non-empty)
        if test -s "$LOCAL_PATH"
          echo "[SKIPPED - EXISTS] $REL_PATH"
          continue
        end

        # Ensure destination directory structure exists locally
        mkdir -p "$LOCAL_DIR"

        echo -n "[DOWNLOADING] $REL_PATH ... "

        # Step C: Download via curl
        if ${pkgs.curl}/bin/curl --fail --silent --show-error --location --output "$LOCAL_PATH" "$FILE_URL"
          echo "OK"
        else
          echo "FAILED"
          # Log failed URL to master skip log
          echo "$FILE_URL" >> "$FAILED_LOG"
          # Delete failed/incomplete download artifact
          rm -f "$LOCAL_PATH"
        end

        sleep $WAIT_SEC
      end

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
