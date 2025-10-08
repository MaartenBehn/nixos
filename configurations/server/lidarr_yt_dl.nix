{ pkgs, ... }: 
let
  valid_check = pkgs.writeShellScriptBin "valid_check" ''
    if [ ! -d "/srv/lidarr-youtube-downloader" ]; then
      cd /srv 
      git clone https://github.com/dmzoneill/lidarr-youtube-downloader.git
      chown -R lidarr:lidarr /srv/lidarr-youtube-downloader 
    fi
  '';

  init = pkgs.writeShellScriptBin "init" ''
    cd /srv/lidarr-youtube-downloader 
    python3 -m venv .venv
    source ./.venv/bin/activate
    python3 -m pip install --no-cache-dir --no-deps -U yt-dlp
    pip3 install --no-cache-dir --break-system-packages requests eyed3 youtube-search-python typer
    pip3 install --no-cache-dir --break-system-packages --force-reinstall 'httpx<0.28'
  '';

  update = pkgs.writeShellScriptBin "update" ''
    cd /srv/lidarr-youtube-downloader/lidarr-youtube-downloader 
        
    source ../.venv/bin/activate
    export LIDARR_URL="http://127.0.0.4:8686"
    export LIDARR_API_KEY="ee7c84e0f9d040b997d8133b14516a8d" # your key
    export LIDARR_DB="/var/lib/lidarr/.config/Lidarr/lidarr.db"
    export LIDARR_MUSIC_PATH="/media/music"

    python3 -u lyd.py
    ''; 

in {
  systemd.services.obsidian_export-valid = {
    path = with pkgs; [
      git
      valid_check
    ];
    script = "valid_check";
  };

  systemd.services.obsidian_export-init = {
    path = with pkgs; [
      bash
      init
    ];
    script = "init";
    serviceConfig.User = "lidarr";
  };
 
  systemd.services.obsidian_export-updater = {
    path = with pkgs; [
      bash
      update
    ];
    script = "lidarr";
    #startAt = "Sat 03:45";  
    #wantedBy = [ "network-online.target" ];
    serviceConfig.User = "lidarr";
  };
}
