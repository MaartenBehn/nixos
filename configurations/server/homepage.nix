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
              siteMonitor = "http://media.home/";
              description = "Media Server";
              icon = "https://jellyfin.org/images/favicon.ico";
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
            Qbittorrent = {
              href = "http://qbittorrent.home";
              siteMonitor = "http://qbittorrent.home/";
              description = "Torrent Downloader";
              icon = "https://www.qbittorrent.org/favicon.svg";
              widget = {
                type = "qbittorrent";
                url = "http://qbittorrent.home";
                username = "stroby";
                password = "qbittorrent+240803";
                enableLeechProgress = true;
              };
            };
          }
          {
            Prowlarr = {
              href = "http://prowlarr.home";
              siteMonitor = "http://prowlarr.home/";
              description = "Torrent Search Engine";
              icon = "https://prowlarr.com/logo/128.png";
              widget = {
                type = "prowlarr";
                url = "http://prowlarr.home";
                key = "08d09cc6bb6f45419174b35542808b4d";
              };
            };
          }
          {
            Sonarr = {
              href = "http://sonarr.home";
              siteMonitor = "http://sonarr.home/";
              #description = "Torrent Search Engine";
              icon = "https://sonarr.tv/img/logo.png";
              widget = {
                type = "sonarr";
                url = "http://som.home";
                key = "8e699f57fe2a40a194c7e8999d7ac95d";
              };
            };
          }
        ];
      }
      {
        Data = [
          {
            FileBrowser = {
              href = "https://files.stroby.ipv64.de";
              siteMonitor = "http://files.home/";
              icon = "https://filebrowser.org/static/logo.png";
            };
          }
          {
            Syncthing = {
              href = "http://syncthing.home";
              siteMonitor = "http://syncthing.home/";
              icon = "https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/Syncthing_Logo.svg/2048px-Syncthing_Logo.svg.png";
            };
          }
          {
            VSCode = {
              href = "http://code.home/?tkn=voZ2d5c7o7lJ6l4C7FDqoaOcWVo2QGzvyf6&folder=/home/stroby/dev";
              siteMonitor = "http://code.home/";
              icon = "https://code.visualstudio.com/assets/favicon.ico";
            };
          }
          {
            Gallery = {
              href = "http://gallery.home";
              siteMonitor = "http://gallery.home/";
            };
          }
        ];
      }
    ];

    widgets = [
      {
        datetime = {
          text_size = "xl";
          format = {
            timeStyle = "short";
            hourCycle = "h23";
          };
        };
      }
      {
        resources = {
          cpu = true;
          cputemp = true;
          units = "metric";
          memory = true;
          network = true;
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
