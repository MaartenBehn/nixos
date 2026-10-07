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

      # Ensure base destination directory exists
      mkdir -p "$DEST_DIR"

      echo "=== Starting Download ==="

      # -o /dev/stdout outputs the log stream
      # tee /dev/stderr prints all log output directly to terminal while piping downstream
      ${pkgs.wget2}/bin/wget2 \
        --max-threads=2 \
        --wait=0.2 \
        --random-wait \
        -r -np -nH -nc \
        --cut-dirs=1 \
        --protocol-directories \
        -R "*.zip,*.ZIP,index.html*" \
        -P "$DEST_DIR" \
        -o /dev/stdout \
        "$BASE_URL" | ${pkgs.coreutils}/bin/tee /dev/stderr | ${pkgs.gnugrep}/bin/grep --line-buffered -E "ERROR|failed" | ${pkgs.gnugrep}/bin/grep --line-buffered -oP 'https://[^\s]+' | while read -l URL
          set REL_PATH (string replace "$BASE_URL" "" "$URL")
          set LOCAL_PATH "$DEST_DIR/$REL_PATH"
          set LOCAL_DIR (${pkgs.coreutils}/bin/dirname "$LOCAL_PATH")

          # Instantly create directory and placeholder file
          mkdir -p "$LOCAL_DIR"
          touch "$LOCAL_PATH"
          echo "[PLACEHOLDER CREATED] $REL_PATH" >&2
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
