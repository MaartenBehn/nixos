let 
  mkDownloader = pkgs: pkgs.writeTextFile {
    name = "asstr-downloader";
    destination = "/bin/asstr-downloader";
    executable = true;

    text = ''
      #!${pkgs.fish}/bin/fish

      # Configuration
      set BASE_URL "https://www.asstr-mirror.org/files/Collections/"
      set DEST_DIR "/media/stories/asstr"
      set FAILED_LOG "$DEST_DIR/failed_uris.txt"
      set WAIT_SEC 0.2

      # Ensure base directories exist
      mkdir -p "$DEST_DIR"
      touch "$FAILED_LOG"

      # In-memory queue of subdirectories to scan
      set DIR_QUEUE "$BASE_URL"

      echo "=== Starting Clean Recursive Crawl & Download ==="

      while test (count $DIR_QUEUE) -gt 0
        # Pop the first directory from queue
        set CURRENT_DIR $DIR_QUEUE[1]
        set -e DIR_QUEUE[1]

        set REL_DIR (${pkgs.fish}/bin/string replace "$BASE_URL" "" "$CURRENT_DIR")
        echo "[CRAWLING DIRECTORY] /$REL_DIR"

        # Fetch index HTML exactly ONCE into memory
        set INDEX_HTML (${pkgs.curl}/bin/curl -sSL "$CURRENT_DIR")

        # Parse all href links from HTML index
        set HREF_LINKS (${pkgs.fish}/bin/string match -r -a 'href="([^"]+)"' "$INDEX_HTML" | ${pkgs.fish}/bin/string replace -r 'href="([^"]+)"' '$1')

        for LINK in $HREF_LINKS
          # Skip parent/query links, index pages, and rejected extensions
          if ${pkgs.fish}/bin/string match -q -r '^\?|^/|index\.html|\.zip$|\.ZIP$' "$LINK"
            continue
          end

          set FULL_URL "$CURRENT_DIR$LINK"

          # 1. If it's a subdirectory, append to queue to scan later
          if ${pkgs.fish}/bin/string match -q -r '/$' "$LINK"
            if not contains "$FULL_URL" $DIR_QUEUE
              set -a DIR_QUEUE "$FULL_URL"
            end
            continue
          end

          # 2. It's a file: Calculate local destination path
          set REL_FILE_PATH (${pkgs.fish}/bin/string replace "$BASE_URL" "" "$FULL_URL")
          set LOCAL_FILE_PATH "$DEST_DIR/$REL_FILE_PATH"
          set LOCAL_TARGET_DIR (${pkgs.coreutils}/bin/dirname "$LOCAL_FILE_PATH")

          # --- CHECK 1: Skip if previously failed ---
          if ${pkgs.gnugrep}/bin/grep -qFx "$FULL_URL" "$FAILED_LOG"
            echo "  [SKIPPED - FAILED PREVIOUSLY] $REL_FILE_PATH"
            continue
          end

          # --- CHECK 2: Skip if already downloaded ---
          if test -s "$LOCAL_FILE_PATH"
            echo "  [SKIPPED - EXISTS] $REL_FILE_PATH"
            continue
          end

          # Prepare local directory
          mkdir -p "$LOCAL_TARGET_DIR"

          echo -n "  [DOWNLOADING] $REL_FILE_PATH ... "

          # Download target file
          if ${pkgs.curl}/bin/curl --fail --silent --show-error --location --output "$LOCAL_FILE_PATH" "$FULL_URL"
            echo "OK"
          else
            echo "FAILED"
            # Append failed URI to master blacklist
            echo "$FULL_URL" >> "$FAILED_LOG"
            # Ensure no partial or 0-byte file remains
            rm -f "$LOCAL_FILE_PATH"
          end

          sleep $WAIT_SEC
        end
      end

      echo "=== Crawl and Download Complete ==="
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
