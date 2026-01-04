{ config, ... }: {
  imports = [
    # Options
    ../../options/domains.nix

    # System
    ./data_drive.nix
    ./error_notify.nix
    ./debug_tools.nix

    # DNS
    ./network.nix
    ./blocky.nix
    ./cloudflare_dyndns.nix
    ./ipv64.nix
    ./duckdns.nix
   
    # Used by others
    ./ntfy.nix
    ./mail.nix
    ./notes.nix
    ./backup_music.nix
   
    # Web services
    ./homepage.nix
    ./landing_page.nix
    ./syncthing.nix
    ./filebrowser.nix
    ./jellyfin.nix
    ./vscode_server.nix
    ./obsidian_export.nix
    ./home_assistant.nix
    ./actual_budget.nix
    ./immich.nix
    ./nextcloud.nix
    ./baikal.nix
    ./manage_my_damn_life.nix
    ./vaultwarden.nix
    ./audio_muse.nix
    ./qbittorrnt.nix
   
    # Game servers
    ./minecraft.nix
  ];

  domains.local = [ "local" ]; 
  domains.public = [ "stroby.org" "stroby.duckdns.org" "stroby.ipv64.de" ]; 
}
