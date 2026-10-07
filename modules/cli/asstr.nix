let 
  mkDownloader = pkgs: pkgs.writeTextFile {
    name = "asstr-downloader";
    destination = "/bin/asstr-downloader";
    executable = true;

    text = ''
      #!${pkgs.fish}/bin/fish

      # Configuration
      set BASE_URL "https://www.asstr-mirror.org/files/Collections/"
      set DEST_DIR "/media/stories/asstr/Collections"
      set FAILED_LOG "$DEST_DIR/failed_uris.txt"

      # Ensure base destination directory and failed log file exist
      mkdir -p "$DEST_DIR"
      touch "$FAILED_LOG"

      echo "=== Starting Download ==="

      # Grep PCRE explanation:
      # - Checks for line containing ERROR or failed (case insensitive)
      # - Extracts http(s) URL stopping at ']', space, or end of token
      ${pkgs.wget2}/bin/wget2 \
        --max-threads=2 \
        --wait=0.2 \
        --random-wait \
        -r -np -nH -nc \
        --cut-dirs=2 \
        -R "*.zip,*.ZIP,index.html*" \
        -P "$DEST_DIR" \
        -o /dev/stdout \
        "$BASE_URL" | ${pkgs.coreutils}/bin/tee /dev/stderr | ${pkgs.gnugrep}/bin/grep --line-buffered -oP "(?i)(?=.*(?:ERROR|failed))https?://[^\s\x5d]+" | while read -l RAW_URL
          # Normalize http -> https to match BASE_URL
          set NORM_URL (string replace "http://" "https://" "$RAW_URL")
          set CLEAN_URL (string trim --right --chars="\x5d\x3e)\x22\x27" "$NORM_URL")
          set REL_PATH (string replace "$BASE_URL" "" "$CLEAN_URL")
          
          set LOCAL_PATH "$DEST_DIR/$REL_PATH"
          set LOCAL_DIR (${pkgs.coreutils}/bin/dirname "$LOCAL_PATH")

          # Instantly create directory, placeholder file, and record to log
          mkdir -p "$LOCAL_DIR"
          touch "$LOCAL_PATH"
          echo "$REL_PATH" >> "$FAILED_LOG"
          echo "[PLACEHOLDER CREATED & LOGGED] $REL_PATH" >&2
        end

      echo "=== Done ==="
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
