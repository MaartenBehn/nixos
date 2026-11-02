{ lib, ... }: let
  secrets = {
    "jellyfin_homepage_key" = { bitwarden = { name = "Jellyfin"; field = "homepage_key"; }; };
    "seer_key" = { bitwarden = { name = "Seer"; field = "key"; }; };
    "qbittorrent_username" = { bitwarden = { name = "qbittorrent"; field = "username"; }; };
    "qbittorrent_password" = { bitwarden = { name = "qbittorrent"; field = "password";}; };
    "slskd_key" = { bitwarden = { name = "slskd"; field = "key"; }; };

    "prowlarr_key" = { bitwarden = { name = "prowlarr"; field = "key"; }; };
    "sonarr_key" = { bitwarden = { name = "sonarr"; field = "key"; }; };
    "radarr_key" = { bitwarden = { name = "radarr"; field = "key"; }; };
    "lidarr_key" = { bitwarden = { name = "lidarr"; field = "key"; }; };
    "whisparr_key" = { bitwarden = { name = "whisparr"; field = "key"; }; };

    "immich_key" = { bitwarden = { name = "Immich"; field = "key"; }; };

    "home_assistant_key" = { bitwarden = { name = "Home Assistant"; field = "key"; }; }; 
    "sparkyfitness_key" = { bitwarden = { name = "sparkyfitness"; field = "key"; }; };
  };

  to_var = (s: "HOMEPAGE_FILE_${lib.toUpper s}");
in {

  my.secrets.server = lib.mapAttrs (name: value: value // {
    owner = "homepage-dashboard";
  }) secrets;

  flake.modules.nixos.server = { config, lib, inputs,  pkgs-unstable, ... }: 
    {
      systemd.services.homepage-dashboard.environment = lib.mapAttrs' (name: value: {
        name = (to_var name);
        value = config.my.secrets.${name}.path;
      }) secrets;
      
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
        package = pkgs-unstable.homepage-dashboard;
        listenPort = 8085;
        allowedHosts = "main.local,127.0.0.1:8085";

        settings = {
          title = "Stroby's Home Server";
          background = {
            image = "http://main.local/wallpapers/forest_road.jpg";
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

                  # TODO: Create function for icon urls 
                  icon = "http://main.local/icons/jellyfin.svg";
                  widget = {
                    type = "jellyfin";
                    url = "https://media.stroby.org/";
                    key = "{{${to_var "jellyfin_homepage_key"}}}";
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
                    key = "{{${to_var "seer_key"}}}";
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
                    username = "{{${to_var "qbittorrent_username"}}}";
                    password = "{{${to_var "qbittorrent_password"}}}";
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
                    key = "{{${to_var "slskd_key"}}}";
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
                    key = "{{${to_var "prowlarr_key"}}}";
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
                    key = "{{${to_var "sonarr_key"}}}";
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
                    key = "{{${to_var "radarr_key"}}}";
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
                    key = "{{${to_var "lidarr_key"}}}";
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
                Fitness = {
                  href = "https://fitness.stroby.org/";
                  description = "Fitness and Nutrition Tracker";
                  icon = "http://main.local/icons/sparkyfitness.webp";
                  widget = {
                    type = "sparkyfitness";
                    url = "https://fitness.stroby.org/";
                    key = "{{${to_var "sparkyfitness_key"}}}";
                  };
                }; 
              }
              {
                HomeAssistant = {
                  href = "http://home.local/";
                  description = "Smart Home";
                  icon = "http://main.local/icons/homeassistant.svg";
                  widget = {
                    type = "homeassistant";
                    url = "http://home.local/";
                    key = "{{${to_var "home_assistant_key"}}}";
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
                    key = "{{${to_var "immich_key"}}}";
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
                  description = "Uni Notes";
                  icon = "http://main.local/icons/obsidian.svg";
                };
              }
              {
                FileBrowser = {
                  href = "https://files.stroby.org";
                  description = "Server Files";
                  icon = "http://main.local/icons/filebrowser.png";
                };
              }
              {
                Syncthing = {
                  href = "http://syncthing.local/";
                  description = "Notes syncing";
                  icon = "http://main.local/icons/syncthing.svg";
                };
              }
              {
                NextCloud = {
                  href = "https://cloud.stroby.org/";
                  description = "Cloude Storage";
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
