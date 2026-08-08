{
  flake.modules.nixos.server = { pkgs, pkgs-unstable, config, ... }: let
    version = "v0.3.37";

    lidarr-youtube-downloader-src = pkgs.fetchFromGitHub {
      owner = "dmzoneill";
      repo = "lidarr-youtube-downloader";
      rev = version;
      hash = "sha256-0000000000000000000000000000000000000000000="; # Replace with accurate hash on build
    };

    youtube-search-python = pkgs.python3.pkgs.buildPythonPackage rec {
      pname = "youtube-search-python";
      version = "1.6.6";
      format = "setuptools";

      src = pkgs.python3.pkgs.fetchPypi {
        inherit pname version;
        hash = "sha256-1234567890abcdef1234567890abcdef1234567890a=";         
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
    sops.templates."lidarr-yt-downloader.env" = {
      content = ''
      LIDARR_API_KEY='${config.sops.placeholder."lidarr_youtube_download/lidarr_key"}'
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

        ReadWritePaths = [
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

