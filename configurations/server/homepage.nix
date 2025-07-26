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
        Services = [
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
          {
            VSCode = {
              href = "https://code.home/?tkn=voZ2d5c7o7lJ6l4C7FDqoaOcWVo2QGzvyf6&folder=/home/stroby/dev";
            };
          }
        ];
      }
    ];

    widgets = {
      jellyfin = {
        type = "jellyfin";
        url = "http://jellyfin.home";
        key = "apikeyapikeyapikeyapikeyapikey";
        enableBlocks = true;
        enableNowPlaying = true;
        enableUser = true;
        enableMediaControl = true;
        showEpisodeNumber = true;
        expandOneStreamToTwoRows = true;
      };
      prowlarr = {
        type = "prowlarr";
        url = "http://prowlarr.home";
        key = "apikeyapikeyapikeyapikeyapikey";
      };
      qbittorrent = {
        type = "qbittorrent";
        url = "http://qbittorrent.home";
        username = "stroby";
        password = "qbittorrent+240803";
        enableLeechProgress = true;
      };
    };

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
