{ config, ... }: let 
  version = config.version; 
in {
  flake.modules.nixos.server = { lib, pkgs, config, ... }: let
    cache-dir = "/var/lib/beets";
    music-dir = "/media/music";
    playlist-dir = "${cache-dir}/playlists";

    plugin_mood = pkgs.callPackage ./_plugin_mood.nix {
      inherit lib pkgs;
      inherit (pkgs) python3Packages;
      beets = pkgs.python3Packages.beets-minimal;
    };

    plugin_beets = (pkgs.python3Packages.beets.override {
      pluginOverrides = {
        mood = {
          enable = true;
          propagatedBuildInputs = [ plugin_mood ];
        };
      };
    });

    wrappedBeets = pkgs.symlinkJoin {
      name = "beets-wrapped";
      paths = [ plugin_beets ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
      wrapProgram $out/bin/beet \
      --set AUDIOREAD_BACKEND ffmpeg \
      --set GST_DEBUG 0 \
      --add-flags --config=${cache-dir}/.config/beets/config.yaml
      '';
    };
  in
    {
    users.users.beets = {
      isSystemUser = true;
      group = "media";
      home = cache-dir;
      createHome = true;
      homeMode = "2770";
    };

    environment.systemPackages = (with pkgs; [ wrappedBeets flac mp3val ]);

    home-manager.users.beets = {
      home.stateVersion = version;       
      programs.beets = {
        enable = true;
        package = wrappedBeets;
        settings = (import ./_settings.nix {
          inherit cache-dir music-dir playlist-dir;
        });
      };
    };

    services.audiomuse-ai.plugins.beets_package = wrappedBeets; 
  };
}
