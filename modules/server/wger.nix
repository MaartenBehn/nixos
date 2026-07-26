{ config, pkgs, lib, ... }:

let
  cfg = config.services.wger;
  wgerUser = "wger";
  wgerGroup = "wger";
  wgerHome = "/var/lib/wger";
  wgerSrc = "${wgerHome}/src";
in
{
  options.services.wger = {
    enable = lib.mkEnableOption "wger Workout & Fitness Manager";

    domain = lib.mkOption {
      type = lib.types.str;
      example = "wger.example.com";
      description = "The FQDN where wger will be served.";
    };

    secretKeySecret = lib.mkOption {
      type = lib.types.str;
      default = "wger_secret_key";
      description = "The key name in sops.secrets for the DJANGO_SECRET_KEY.";
    };

    timeZone = lib.mkOption {
      type = lib.types.str;
      default = "UTC";
      example = "Europe/Berlin";
      description = "Time zone for Django.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8000;
      description = "Internal port for Gunicorn WSGI server.";
    };
  };

  config = lib.mkIf cfg.enable {
    # 1. Register secret requirement in sops-nix
    sops.secrets."${cfg.secretKeySecret}" = {
      owner = wgerUser;
      group = wgerGroup;
      mode = "0400";
    };

    # 2. System user and group
    users.users.${wgerUser} = {
      isSystemUser = true;
      group = wgerGroup;
      home = wgerHome;
      createHome = true;
    };
    users.groups.${wgerGroup} = {};

    # 3. Systemd service for wger Gunicorn & Setup
    systemd.services.wger = {
      description = "wger Workout & Fitness Manager (Gunicorn)";
      after = [ "network.target" "sops-nix.service" ];
      requires = [ "sops-nix.service" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        HOME = wgerHome;
        PYTHONPATH = wgerSrc;
        DJANGO_SETTINGS_MODULE = "settings.main";
        DJANGO_DB_ENGINE = "django.db.backends.sqlite3";
        DJANGO_DB_NAME = "${wgerHome}/db/database.sqlite";
        DJANGO_MEDIA_ROOT = "${wgerHome}/media";
        DJANGO_STATIC_ROOT = "${wgerHome}/static";
        TIME_ZONE = cfg.timeZone;
        ALLOWED_HOSTS = "${cfg.domain},localhost,127.0.0.1";
      };

      path = with pkgs; [
        python311
        uv
        nodejs_22
        nodePackages.sass
        git
        ffmpeg
        gettext
      ];

      script = ''
        set -euo pipefail

        # Read secret key from sops-nix decrypted file
        export DJANGO_SECRET_KEY="$(cat ${config.sops.secrets."${cfg.secretKeySecret}".path})"

        # Ensure directory structure
        mkdir -p ${wgerHome}/{db,static,media}

        # Clone or update wger source repository
        if [ ! -d "${wgerSrc}/.git" ]; then
          git clone https://github.com/wger-project/wger.git "${wgerSrc}"
        fi

        cd "${wgerSrc}"

        # Sync Python environment using uv with docker group dependencies
        uv sync --group docker --no-managed-python --python ${pkgs.python311}/bin/python

        # Activate virtualenv
        source .venv/bin/activate

        # Perform Django setup tasks
        python manage.py migrate --noinput
        python manage.py collectstatic --noinput

        # Compile message catalogs
        cd wger
        django-admin compilemessages || true
        cd ..

        # Run WSGI server
        exec gunicorn wger.wsgi:application \
          --preload \
          --bind 127.0.0.1:${toString cfg.port} \
          --workers 3 \
          --threads 2 \
          --worker-class gthread \
          --timeout 240 \
          --access-logfile -
      '';

      serviceConfig = {
        User = wgerUser;
        Group = wgerGroup;
        WorkingDirectory = wgerHome;
        StateDirectory = "wger";
        Restart = "always";
        RestartSec = "5s";
      };
    };

    # 4. Nginx Reverse Proxy
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;

      virtualHosts."${cfg.domain}" = {
        forceSSL = true;
        enableACME = true;

        locations."/static/" = {
          alias = "${wgerHome}/static/";
          extraConfig = ''
            expires 30d;
            add_header Cache-Control "public, no-transform";
          '';
        };

        locations."/media/" = {
          alias = "${wgerHome}/media/";
        };

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };

    # Allow Nginx worker to read static/media owned by wger group
    users.users.nginx.extraGroups = [ wgerGroup ];
  };

  flake.modules.nixos.server = {
    services.wger = {
      enable = true;
      domain = "wger.yourdomain.com";
      secretKeySecret = "wger_secret_key"; # Matches your sops secret entry
      timeZone = "Europe/Berlin";
    };
  };
}
