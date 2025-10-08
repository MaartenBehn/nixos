{ pkgs, ... }: 
let 
  init = pkgs.writeShellScriptBin "init" ''
    cd /srv
    rm -r lidarr-youtube-downloader 
    git clone https://github.com/dmzoneill/lidarr-youtube-downloader.git
    cd lidarr-youtube-downloader 

    python3 -m venv .venv
    source ./.venv/bin/activate
    python3 -m pip install --no-cache-dir --no-deps -U yt-dlp
    pip3 install --no-cache-dir --break-system-packages requests eyed3 youtube-search-python typer
    pip3 install --no-cache-dir --break-system-packages --force-reinstall 'httpx<0.28'
  '';

  update = pkgs.writeShellScriptBin "update" ''
    cd /srv/lidarr-youtube-downloader/lidarr_youtube_downloader 
        
    source ../.venv/bin/activate
    export LIDARR_URL="http://192.168.15.1:8686/"
    export LIDARR_API_KEY="ee7c84e0f9d040b997d8133b14516a8d" # your key
    export LIDARR_DB="/var/lib/lidarr/.config/Lidarr/lidarr.db"
    export LIDARR_MUSIC_PATH="/media/music"

    python3 -u lyd.py
    ''; 

in { 
  systemd.services.lidarr-youtube-downloader-init = {
    vpnConfinement = {
      enable = false;
      vpnNamespace = "mullvad";
    };

    path = with pkgs; [
      bash
      git
      python3
      init
    ];
    script = "init";
    serviceConfig.User = "lidarr";
  };
 
  systemd.services.lidarr-youtube-downloader-updater = {
    vpnConfinement = {
      enable = false;
      vpnNamespace = "mullvad";
    };

    path = with pkgs; [
      bash
      update
    ];
    script = "update";
    #startAt = "Sat 03:45";  
    #wantedBy = [ "network-online.target" ];
    serviceConfig.User = "lidarr";
  };
}
