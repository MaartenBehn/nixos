{ pkgs-unstable, local_domain, ... }: {
  services.homepage-dashboard = {
    # https://gethomepage.dev/

    enable = true;
    package = pkgs-unstable.homepage-dashboard;
    listenPort = 8085;
    allowedHosts = "main.home,127.0.0.1:8084";

    settings = {
      title = "Stroby's Home Server";
      background = {
        image = "/home/stroby/nixos/wallpapers/others/horizon-zero-dawn-aloy-scenery-game-art-landscape-5k-4480x2520-4414.jpg";
        #blur = "sm";
      };
      cardBlur = "xs";
      theme = "dark";
      color = "slate";
    };

    bookmarks = [];

    services = [
      {
        Media = [
          {
            Jellyfin = {
              #icon: "img."
              href = "http://media.home";
              description = "Media Server";
              widget = {
                type = "jellyfin";
                url = "http://media.home";
                key = "cca46e527a534e758a9cd74c398079e3";
                enableBlocks = true;
                enableNowPlaying = true;
                enableUser = true;
                enableMediaControl = true;
                showEpisodeNumber = true;
                expandOneStreamToTwoRows = true;
              };
            };
          }
          {
            Prowlarr = {
              #icon: "img."
              href = "http://prowlarr.home";
              description = "Torrent Search Engine";
              widget = {
                type = "prowlarr";
                url = "http://prowlarr.home";
                key = "08d09cc6bb6f45419174b35542808b4d";
              };
            };
          }
          {
            Qbittorrent = {
              href = "http://qbittorrent.home";
              description = "Torrent Downloader";
              widget = {
                type = "qbittorrent";
                url = "http://qbittorrent.home";
                username = "stroby";
                password = "qbittorrent+240803";
                enableLeechProgress = true;
              };
            };
          }
        ];
      }
      {
        Files = [
          {
            FileBrowser = {
              href = "https://files.stroby.ipv64.de";
            };
          }
          {
            Syncthing = {
              href = "http://syncthing.home";
            };
          }
        ];
        Code = [
          {
            VSCode = {
              href = "https://code.home/?tkn=voZ2d5c7o7lJ6l4C7FDqoaOcWVo2QGzvyf6&folder=/home/stroby/dev";
            };
          }
          {
            Gallery = {
              href = "http://gallery.home";
            };
          }
        ];
      }
    ];

    widgets = [
      {
        resources = {
          cpu = true;
          memory = true;
          disk = "/";
        };
      }
    ];

    kubernetes = { };

    docker = { };

    customJS = "";
    customCSS = "";
  };

  services.nginx.virtualHosts = {
    "main.${local_domain}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8085/"; 
      };

      serverAliases = [
        "www.main.${local_domain}"
      ];
    };
  };
}
