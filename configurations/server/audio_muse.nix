{ pkgs, config, ... }:
let 
  valid_check = pkgs.writeShellScriptBin "valid_check" ''
    if [ ! -d "/srv/AudioMuse-AI" ]; then
      cd /srv 
      git clone https://github.com/MaartenBehn/AudioMuse-AI.git
      chown -R audio_muse:docker /srv/AudioMuse-AI
    fi

    if [ ! -d "/srv/AudioMuse-AI-MusicServer" ]; then
      cd /srv 
      git clone https://github.com/MaartenBehn/AudioMuse-AI-MusicServer.git
      chown -R audio_muse:nginx /srv/AudioMuse-AI-MusicServer
    fi
  '';
  run = pkgs.writeShellScriptBin "run" ''
    cd /srv/AudioMuse-AI

    POSTGRES_PW=$(cat ${config.sops.secrets."audio_muse/user_id".path})
    psql audio_muse -c "ALTER USER audio_muse WITH PASSWORD '$POSTGRES_PW';"

    git pull
    cd deployment

    USER_ID=$(cat ${config.sops.secrets."audio_muse/user_id".path})
    TOKEN=$(cat ${config.sops.secrets."audio_muse/jellyfin_token".path})

    echo "
    MEDIASERVER_TYPE=jellyfin
    JELLYFIN_URL=http://127.0.0.1:8096/
    JELLYFIN_USER_ID=$USER_ID
    JELLYFIN_TOKEN=$TOKEN

    POSTGRES_USER=audio_muse
    POSTGRES_PASSWORD=$POSTGRES_PW
    POSTGRES_DB=audio_muse
    " > .env

    docker compose -f docker-compose.yaml up -d
  '';

  build_server = pkgs.writeShellScriptBin "build_server" ''
    cd /srv/AudioMuse-AI-MusicServer
    
    git pull
    
    cd music-server-backend
    go mod init music-server-backend
    go mod tidy
    go build -o music-server

    cd ../music-server-frontend
    npm install
    npm run build
  '';

  run_server = pkgs.writeShellScriptBin "run_server" ''
    cd /srv/AudioMuse-AI-MusicServer/music-server-backend
    export DATABASE_PATH=/home/audio_muse/.config/audio_muse_server/music.db;
    echo $DATABASE_PATH;
    ./music-server  
  '';
  
in {
  imports = [ ../docker.nix ];

  services.postgresql = {
    ensureDatabases = [ "audio_muse" ];
    ensureUsers = [ 
      { 
        name = "audio_muse";
        ensureDBOwnership = true;
      }
    ];
  };

  sops.secrets = {
    "audio_muse/user_id" = { owner = "audio_muse"; };
    "audio_muse/jellyfin_token" = { owner = "audio_muse"; };
    "audio_muse/postgres/pw" = { owner = "audio_muse"; };
  };

  users.users.audio_muse = {
    isNormalUser = true;
    group = "nginx";
    extraGroups = [
      "docker"
      "media"
    ];
  };

  systemd.services.audio_muse-valid = {
    path = with pkgs; [
      git
      valid_check
    ];
    script = "valid_check";
  };

  systemd.services.audio_muse-run = {
    path = with pkgs; [
      git
      docker
      postgresql
      run
    ];
    script = "run";
    serviceConfig.User = "audio_muse";
    wantedBy = [ "network-online.target" ];
    after = [ "network.target" ];
  };

  systemd.services.audio_muse-server-build = {
    path = with pkgs; [
      git
      go
      gccgo
      nodejs
      bash
      build_server
    ];
    script = "build_server";
    serviceConfig.User = "audio_muse";
  };

  systemd.services.audio_muse_server-run = {
    path = [
      run_server
    ];
    script = "run_server";
    serviceConfig.User = "audio_muse";
    wantedBy = [ "network-online.target" ];
    after = [ "network.target" ];
  };

  networking.firewall.allowedTCPPorts = [ 8000 ];
  networking.firewall.allowedUDPPorts = [ 8000 ];

  web_services = {
    "audio_muse" = {
      domains = "local";
      loc = {
        proxyPass = "http://172.17.0.1:8000/";
        proxyWebsockets = true;
      };
    };
    "audio_muse_server" = {
      domains = "local";
      loc = {
        proxyPass = "http://127.0.0.1:8081/";
      };
    };
  };
}
