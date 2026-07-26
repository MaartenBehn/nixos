{
  flake.modules.nixos.core = { config, pkgs, lib, ... }:

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

        secretKeyFile = lib.mkOption {
          type = lib.types.path;
        };

        jwt_private_key_file = lib.mkOption {
          type = lib.types.path;
        };

        jwt_public_key_file = lib.mkOption {
          type = lib.types.path;
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

        release = lib.mkOption {
          type = lib.types.str;
        };
      };

      config = lib.mkIf cfg.enable {
        # System user and group
        users.users.${wgerUser} = {
          isSystemUser = true;
          group = wgerGroup;
          home = wgerHome;
          createHome = true;
        };
        users.groups.${wgerGroup} = {};

        # Systemd service for wger Gunicorn & Setup
        systemd.services.wger = {
          description = "wger Workout & Fitness Manager (Gunicorn)";
          wantedBy = [ "multi-user.target" ];
          wants = [ "network.target" ];
          after = [ "network.target" ];

          environment = {
            HOME = wgerHome;
            PYTHONPATH = wgerSrc;
            DJANGO_SETTINGS_MODULE = "settings.main";
            DJANGO_DB_ENGINE = "django.db.backends.sqlite3";
            DJANGO_DB_NAME = "${wgerHome}/db/database.sqlite"; # TODO: Can remove?
            DJANGO_DB_DATABASE = "${wgerHome}/db/database.sqlite";
            DJANGO_DB_USER = "wger";
            DJANGO_DB_PASSWORD = "wger";
            DJANGO_DB_HOST = "localhost";
            DJANGO_DB_PORT = "5433";             
            DJANGO_MEDIA_ROOT = "${wgerHome}/media";
            DJANGO_STATIC_ROOT = "${wgerHome}/static";
            TIME_ZONE = cfg.timeZone;
            ALLOWED_HOSTS = "${cfg.domain},www.${cfg.domain},localhost,127.0.0.1";          
          };

          path = with pkgs; [
            python312
            uv
            nodejs_22
            nodePackages.sass            
            git
            ffmpeg
            gettext
            bash
          ];

          script = ''
        set -euo pipefail

        export DJANGO_SECRET_KEY="$(cat ${cfg.secretKeyFile})"
        export SECRET_KEY="$(cat ${cfg.secretKeyFile})"
        export JWT_PRIVATE_KEY="$(cat ${cfg.jwt_private_key_file})"
        export JWT_PUBLIC_KEY="$(cat ${cfg.jwt_public_key_file})"

        mkdir -p ${wgerHome}/{db,static,media}

        if [ ! -d "${wgerSrc}/.git" ]; then
          git clone https://github.com/wger-project/wger.git "${wgerSrc}"

          cd "${wgerSrc}"

          # Sync Python environment using uv
          uv sync --group docker --no-managed-python --python ${pkgs.python312}/bin/python

          # Activate virtualenv
          source .venv/bin/activate

          wger bootstrap

          python manage.py collectstatic --noinput --clear         
          #python manage.py generate-jwt-keys || true

          # Compile message catalogs
          cd wger
          django-admin compilemessages || true
          cd ..
        fi

        cd "${wgerSrc}"
        source .venv/bin/activate
        python manage.py sync-exercises
        python3 manage.py download-exercise-images
        python3 manage.py download-exercise-videos
        # python3 manage.py sync-ingredients-bulk --set-mode update
        wger load-online-fixtures
        python3 manage.py setup-powersync-storage
        
        # Run WSGI server
        exec gunicorn wger.wsgi:application \
          --preload \
          --bind 127.0.0.1:${toString cfg.port} \
          --workers 3 \
          --threads 2 \
          --worker-class gthread \
          --timeout 240 \
          --access-logfile - \
          --error-logfile - \
          --capture-output      
      '';
          serviceConfig = {
            User = wgerUser;
            Group = wgerGroup;
            WorkingDirectory = wgerHome;
            StateDirectory = "wger";
          };
        };   
      };
    };
}
