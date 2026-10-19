{
  flake.modules.homeManager.server = { lib, pkgs, ... }: let
      cache-dir = "/home/stroby/.config/beets";
      music-dir = "/media/music";
      playlist-dir = "${cache-dir}/playlists";

    wrappedBeets = pkgs.symlinkJoin {
      name = "beets-wrapped";
      paths = [ pkgs.beets ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
      wrapProgram $out/bin/beet \
      --set AUDIOREAD_BACKEND ffmpeg \
      --set GST_DEBUG 0
      '';
    };
  in
      {
      home.packages = (with pkgs; [ flac mp3val ]);

      programs.beets = {
        enable = true;
        package = wrappedBeets;
        settings =
          (import ./_settings.nix {
            inherit cache-dir music-dir playlist-dir;
          });
      };
    };
}
