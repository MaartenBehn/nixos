{
  flake.modules.nixos.server = { pkgs, ... }: {
    services.navidrome = {
      enable = true;
  
      services.navidrome.package = pkgs.navidrome;

      settings = {
        MusicFolder = "/media/music";
        Address = "127.0.0.1";
        Port = 4533;
        EnableSharing = true;
      };

      plugins = with pkgs.navidromePlugins; [
        audiomuseai
        #listenbrainz-daily-playlist
        lyrics-plugin
      ];
    };

    users.groups.media.members = [ "navidrome" ];

    web_services."seerr" = {
      domains = "local";
      root = {
        proxyPass = "http://127.0.0.1:5055/"; 
      };
    };
  };
}
