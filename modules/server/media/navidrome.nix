{
  flake.modules.nixos.server = { pkgs, ... }: {
    services.navidrome = {
      enable = true;

      settings = {
        MusicFolder = "/media/music";
        Address = "127.0.0.1";
        Port = 4533;
        EnableSharing = true;
      };

      plugins = with pkgs.navidromePlugins; [
        #audiomuseai
        #listenbrainz-daily-playlist
        #lyrics-plugin
      ];
    };

    users.groups.media.members = [ "navidrome" ];

    web_services."navidrome" = {
      domains = "all";
      root = {
        proxyPass = "http://127.0.0.1:4533/"; 
      };
    };
  };
}
