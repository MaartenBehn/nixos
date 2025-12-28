{ pkgs, domains, local_domain, config, ... }:
let 
  valid_check = pkgs.writeShellScriptBin "valid_check" ''
    if [ ! -d "/srv/AudioMuse-AI" ]; then
      cd /srv 
      git clone https://github.com/MaartenBehn/AudioMuse-AI.git
      chown -R audio_muse:docker /srv/AudioMuse-AI
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
    group = "docker";
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
 
  services.nginx.virtualHosts."audio_muse.home" = {
    enableACME = false;
    forceSSL = false;
    locations."/" = {
      proxyPass = "http://172.0.0.1:8000/";
    };
    
    serverAliases = [
          "www.audio_muse.home"
      ];
  };
}
