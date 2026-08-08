{
  flake.modules.nixos.server = { pkgs, pkgs-unstable, config, ... }: let
    version = "v0.3.37";

    lidarr-youtube-downloader-src = pkgs.fetchFromGitHub {
      owner = "dmzoneill";
      repo = "lidarr-youtube-downloader";
      rev = version;
      hash = "sha256-Cje78NGx+R9ZQKu9h5OY2egfCgu1GAxYi6WP4uBDXHY=";
    };

    youtube-search-python = pkgs.python3.pkgs.buildPythonPackage rec {
      pname = "youtube-search-python";
      version = "1.6.6";
      format = "setuptools";

      src = pkgs.python3.pkgs.fetchPypi {
        inherit pname version;
        hash = "sha256-RWjR12ns1+tLuDZfBO7G42TF9w7sezdl9UPa67E1/PU=";         
      };
      doCheck = false;
      nativeBuildInputs = with pkgs.python3.pkgs; [ setuptools ];
      propagatedBuildInputs = with pkgs.python3.pkgs; [ httpx ];
    };

    lidarr-youtube-downloader = pkgs.python3.pkgs.buildPythonApplication {
      pname = "lidarr-youtube-downloader";
      inherit version;
      format = "pyproject";

      src = lidarr-youtube-downloader-src;

      # Patch out the invalid script entrypoint in pyproject.toml
      postPatch = ''
        substituteInPlace pyproject.toml \
          --replace-fail 'lyd-unmapped = "lidarr_youtube_downloader.lyd-unmapped:app"' 'lyd-unmapped = "lidarr_youtube_downloader.lyd_unmapped:app"'
      '';

      nativeBuildInputs = [ pkgs.python3.pkgs.poetry-core ];

      propagatedBuildInputs = with pkgs.python3.pkgs; [
        requests
        eyed3
        typer
        yt-dlp
        youtube-search-python
      ];
    };
  in {
    sops.secrets."lidarr/api_key" = { };

    sops.templates."lidarr-yt-downloader.env" = {
      content = ''
        LIDARR_API_KEY='${config.sops.placeholder."lidarr/api_key"}'
      '';
      owner = "lidarr-yt-downloader";
    };

    users.users.lidarr-yt-downloader = {
      isSystemUser = true;
      group = "media";
      description = "Lidarr YouTube Downloader Service User";
    };

    systemd.services.lidarr-youtube-downloader = {
      description = "Lidarr YouTube Downloader Sync Job";
      after = [ "network.target" "lidarr.service" ];

      vpnConfinement = {
        enable = true;
        vpnNamespace = "mullvad";
      };

      path = [
        pkgs.ffmpeg
        pkgs.yt-dlp
      ];

      environment = {
        LIDARR_URL = "http://192.168.15.1:8686/";
        LIDARR_DB = "/var/lib/lidarr/lidarr.db"; 
        LIDARR_MUSIC_PATH = "/media/music";
        MATCH_THRESHOLD = "0.8";
      };

      serviceConfig = {
        Type = "oneshot";
        User = "lidarr-yt-downloader";
        Group = "media";

        ExecStart = "${lidarr-youtube-downloader}/bin/lyd";

        EnvironmentFile = config.sops.templates."lidarr-yt-downloader.env".path;

        StateDirectory = "lidarr-youtube-downloader";
        WorkingDirectory = "/var/lib/lidarr-youtube-downloader";

        ReadWritePaths = [
          "/var/lib/lidarr-youtube-downloader"
          "/media/music"
          "/var/lib/lidarr"
        ];

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        NoNewPrivileges = true;
      };
    };

    systemd.timers.lidarr-youtube-downloader = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        RandomizedDelaySec = "1h";
      };
    };
  };
}
