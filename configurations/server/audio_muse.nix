{ pkgs, domains, local_domain, config, ... }:
let 
  valid_check = pkgs.writeShellScriptBin "valid_check" ''
    if [ ! -d "/srv/AudioMuse-AI" ]; then
      cd /srv 
      git clone https://github.com/NeptuneHub/AudioMuse-AI.git
      chown -R audio_muse:docker /srv/AudioMuse-AI
    fi
  '';
  run = pkgs.writeShellScriptBin "run" ''
    cd /srv/AudioMuse-AI

    git pull
    cd deployment

    USER_ID=$(cat ${config.sops.secrets."audio_muse/user_id".path})
    TOKEN=$(cat ${config.sops.secrets."audio_muse/jellyfin_token".path})

    echo "
    MEDIASERVER_TYPE=jellyfin
    JELLYFIN_URL=http://127.0.0.1:8096/
    JELLYFIN_USER_ID=$USER_ID
    JELLYFIN_TOKEN=$TOKEN
    " > .env

    docker compose -f deployment/docker-compose.yaml up -d
  '';
  
in {
  imports = [ ../docker.nix ];

  sops.secrets = {
    "audio_muse/user_id" = { owner = "audio_muse"; };
    "audio_muse/jellyfin_token" = { owner = "audio_muse"; };
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
      run
    ];
    script = "run";
    serviceConfig.User = "audio_muse";
    wantedBy = [ "network-online.target" ];
    after = [ "network.target" ];
  };
 
  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "audio_muse.${domain}"; 
    value = {
      enableACME = domain != local_domain;
      forceSSL = domain != local_domain;
      locations."/" = {
      };

      serverAliases = [
        "www.audio_muse.${domain}"
      ];
    };
  }) (domains ++ [ local_domain ]));
}
