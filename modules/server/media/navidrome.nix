{
  flake.modules.nixos.server = { pkgs, config, ... }: {
    
    sops.templates."navidrome.env" = {
        content = ''
          ND_PLUGINS_ENABLED=true
          ND_PLUGINS_AUTORELOAD=true
          ND_AGENTS=audiomuseai
          ND_DEVARTISTINFOTIMETOLIVE=1s        
        '';
        owner = "navidrome";
      };
      #ND_AGENTS=audiomuseai,lastfm


    services.navidrome = {
      enable = true;

      package = pkgs.navidrome.overrideAttrs (oldAttrs: {
        doCheck = false;
      });

      environmentFile = config.sops.templates."navidrome.env".path;

      settings = {
        MusicFolder = "/media/music";
        Address = "127.0.0.1";
        Port = 4533;
        EnableSharing = true;
        CoverArtPriority = "cover.*, folder.*, front.*, embedded";
        EnableMediaFileCoverArt = false;
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
