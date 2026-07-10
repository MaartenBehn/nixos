{
  flake.modules.nixos.server = { config, lib, inputs, ... }: 
  let
    secrets = [
      "jellyfin/key"
      "jellyseer/key"
      "qbittorrent/username"
      "qbittorrent/password"
      "slskd/key"

      "prowlarr/key"
      "sonarr/key"
      "radarr/key"
      "lidarr/key"
      "whisparr/key"
      
      "home_assistant/key"
      
      "immich/key"
    ];

    to_var = (s: "HOMEPAGE_FILE_${lib.toUpper (builtins.replaceStrings ["/"] ["_"] s)}");
    to_sops = (s: "homepage/${s}");
    
    secret_vars = (builtins.foldl' 
      lib.recursiveUpdate 
      {} 
      (builtins.map 
        (s: builtins.foldl' 
          (set: s: builtins.listToAttrs [{ name = s; value = set; }])
          (to_var s)
          (lib.lists.reverseList (lib.strings.splitString "/" s)) 
        ) 
        secrets
      )
    );

    secret_environment = builtins.listToAttrs (builtins.map (s: 
      {
        name = (to_var s);
        value = config.sops.secrets.${to_sops s}.path;
      }
    ) secrets);

    secret_sops = builtins.listToAttrs (builtins.map (s: 
      {
        name = to_sops s;
        value = {
          owner = "homepage-dashboard";
        };
      }
    ) secrets);

  in {
    systemd.services.homepage-dashboard.environment = secret_environment;
    sops.secrets = secret_sops;

    users.users.homepage-dashboard = {
      isSystemUser = true;
      group = "nginx";
    };

    systemd.services.homepage-dashboard = {
      serviceConfig.User = "homepage-dashboard";
    };
    
    services.homepage-dashboard = {
      # https://gethomepage.dev/

      enable = true;
      #package = pkgs-unstable.homepage-dashboard;
      listenPort = 8085;
      allowedHosts = "main.local,127.0.0.1:8085";

      settings = {
        title = "Stroby's Home Server";
        background = {
          image = "http://main.local/wallpapers/horizon-zero-dawn.jpg";
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
                href = "https://media.stroby.org/";
                description = "Media Server";
                icon = "http://main.local/icons/jellyfin.svg";
                widget = {
                  type = "jellyfin";
                  url = "https://media.stroby.org/";
                  key = "{{${secret_vars.jellyfin.key}}}";
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
              Jellyseerr = {
                href = "http://seerr.local/";
                description = "Media Requester";
                icon = "http://main.local/icons/jellyseerr.png";
                widget = {
                  type = "jellyseerr";
                  url = "http://seerr.local/";
                  key = "{{${secret_vars.jellyseer.key}}}";
                };
              };
            }
            {
              Qbittorrent = {
                href = "http://qbittorrent.local/";
                description = "Torrent Downloader";
                icon = "http://main.local/icons/qbittorrent.svg";
                widget = {
                  type = "qbittorrent";
                  url = "http://qbittorrent.local/";
                  username = "{{${secret_vars.qbittorrent.username}}}";
                  password = "{{${secret_vars.qbittorrent.password}}}";
                  enableLeechProgress = true;
                };
              };
            }
            {
              Slskd = {
                href = "http://slskd.local/";
                description = "Usenet Downloader";
                icon = "http://main.local/icons/slskd.ico";
                widget = {
                  type = "slskd";
                  url = "http://slskd.local/";
                  key = "{{${secret_vars.slskd.key}}}";
                };
              };
            }
            {
              Prowlarr = {
                href = "http://prowlarr.local/";
                description = "Indexer Manager";
                icon = "http://main.local/icons/prowlarr.svg";
                widget = {
                  type = "prowlarr";
                  url = "http://prowlarr.local/";
                  key = "{{${secret_vars.prowlarr.key}}}";
                };
              };
            }
            {
              Sonarr = {
                href = "http://sonarr.local/";
                description = "Show Search Engine";
                icon = "http://main.local/icons/sonarr.svg";
                widget = {
                  type = "sonarr";
                  url = "http://sonarr.local/";
                  key = "{{${secret_vars.sonarr.key}}}";
                };
              };
            }
            {
              Radarr = {
                href = "http://radarr.local/";
                description = "Movie Search Engine";
                icon = "http://main.local/icons/radarr.svg";
                widget = {
                  type = "radarr";
                  url = "http://radarr.local/";
                  key = "{{${secret_vars.radarr.key}}}";
                  enableQueue = true;
                };
              };
            }
            {
              Lidarr = {
                href = "http://lidarr.local/";
                description = "Music Search Engine";
                icon = "http://main.local/icons/lidarr.svg";
                widget = {
                  type = "lidarr";
                  url = "http://lidarr.local/";
                  key = "{{${secret_vars.lidarr.key}}}";
                };
              };
            }
            {
              Whisparr = {
                href = "http://whisparr.local/";
                description = "Adult Search Engine";
                icon = "http://main.local/icons/whisparr.svg";
              };
            }
            {
              AudioMuse = {
                href = "http://audio_muse.local/";
                description = "Music Embedding Engine";
                icon = "http://main.local/icons/audiomuse.png";
              };
            }
          ];
        }
        {
          Home = [
            {
              HomeAssistant = {
                href = "http://home.local/";
                description = "Smart Home";
                icon = "http://main.local/icons/homeassistant.svg";
                widget = {
                  type = "homeassistant";
                  url = "http://home.local/";
                  key = "{{${secret_vars.home_assistant.key}}}";
                  custom = [
                    {
                      state = "sensor.plug_asus_energy_total";
                      label = "Server usage total";
                    }
                    {
                      state = "sensor.plug_asus_energy_today";
                      label = "Server usage today";
                    }
                  ];
                };
              };
            }
            {
              "Actual Budget" = {
                href = "http://budget.stroby.org";
                description = "Budgeting App";
                icon = "http://main.local/icons/actualbudget.svg";
              };
            }
            {
              Immich = {
                href = "https://immich.stroby.org/";
                description = "Fotos";
                icon = "http://main.local/icons/immich.ico";
                widget = {
                  type = "immich";
                  url = "https://immich.stroby.org/";
                  key = "{{${secret_vars.immich.key}}}";
                  version = 2;
                };
              };
            }
            {
              Calendar = {
                href = "http://calendar.stroby.org";
                description = "Calendar Web App";
                icon = "http://main.local/icons/mmdl.jpeg";
              };
            }
            {
              Baikal = {
                href = "http://baikal.stroby.org";
                description = "Caldav Server";
                icon = "http://main.local/icons/baikal.svg";
              };
            }
            {
              ntfy = {
                href = "http://ntfy.stroby.org";
                description = "Notification Server";
                icon = "http://main.local/icons/ntfy.svg";
              };
            }
            {
              Vaultwarden = {
                href = "http://vaultwarden.stroby.org";
                description = "Password Manager";
                icon = "http://main.local/icons/vaultwarden.svg";
              };
            }
          ];
        }
        {
          Data = [
                      {
              Notes = {
                href = "http://notes.stroby.org";
                icon = "http://main.local/icons/obsidian.svg";
              };
            }
            {
              FileBrowser = {
                href = "https://files.stroby.org";
                icon = "http://main.local/icons/filebrowser.png";
              };
            }
            {
              Syncthing = {
                href = "http://syncthing.local/";
                icon = "http://main.local/icons/syncthing.svg";
              };
            }
            {
              NextCloud = {
                href = "https://cloud.stroby.org/";
                icon = "http://main.local/icons/nextcloud.svg";
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
            #network = true;
            #disk = "/";
          };
        }
      ];

      kubernetes = { };

      docker = { };

      customJS = "";
      customCSS = "";
    };

    web_services."main" = {
      domains = "local";
      root = {
        proxyPass = "http://127.0.0.1:8085/"; 
      };

      locations = {
        "/icons/" = {
          alias = "${../../assets/icons}/";
          extraConfig = ''
            allow all;
            expires 30d;
          '';
        };
        "/wallpapers/"  = {
          alias = "${../../assets/wallpapers}/";
          extraConfig = ''
            allow all;
            expires 30d;
          '';
        };
      };
    };
  };
}
