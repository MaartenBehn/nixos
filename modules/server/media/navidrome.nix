{
  flake.modules.nixos.server = { pkgs, ... }: {
    services.navidrome = {
      enable = true;

      package = pkgs.navidrome.overrideAttrs (oldAttrs: {
        doCheck = false;
      });

      settings = {
        MusicFolder = "/media/music";
        Address = "127.0.0.1";
        Port = 4533;
        EnableSharing = true;
      };

      plugins = with pkgs.navidromePlugins; [
        (audiomuseai.overrideAttrs (oldAttrs: {
          env = (oldAttrs.env or {}) // {
            GOOS = "wasip1";
            GOARCH = "wasm";
          };

          buildPhase = ''
            runHook preBuild
            go build \
              -buildmode=c-shared \
              -o $GOPATH/bin/plugin.wasm .
            runHook postBuild
          '';
        }))        
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
