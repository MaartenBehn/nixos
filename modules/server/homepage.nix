{ lib, ... }: let
  secrets = {
    "jellyfin_homepage_key" = { bitwarden = { name = "Jellyfin"; field = "homepage_key"; }; };
    "seer_key" = { bitwarden = { name = "Seerr"; field = "key"; }; };
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
        allowedHosts = "main.${config.domains.local},127.0.0.1:8085";

        settings = {
          title = "Stroby's Home Server";
          background = {
            image = "http://main.${config.domains.local}/wallpapers/forest_road.jpg";
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
                  href = "https://media.${config.domains.public}/";
                  description = "Media Server";

                  # TODO: Create function for icon urls 
                  icon = "https://main.${config.domains.local}/icons/jellyfin.svg";
                  widget = {
                    type = "jellyfin";
                    url = "https://media.${config.domains.public}/";
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
                  href = "https://seerr.${config.domains.local}/";
                  description = "Media Requester";
                  icon = "https://main.${config.domains.local}/icons/jellyseerr.png";
                  widget = {
                    type = "jellyseerr";
                    url = "https://seerr.${config.domains.local}/";
                    key = "{{${to_var "seer_key"}}}";
                  };
                };
              }
              {
                Qbittorrent = {
                  href = "https://qbittorrent.${config.domains.local}/";
                  description = "Torrent Downloader";
                  icon = "https://main.${config.domains.local}/icons/qbittorrent.svg";
                  widget = {
                    type = "qbittorrent";
                    url = "https://qbittorrent.${config.domains.local}/";
                    username = "{{${to_var "qbittorrent_username"}}}";
                    password = "{{${to_var "qbittorrent_password"}}}";
                    enableLeechProgress = true;
                  };
                };
              }
              {
                Slskd = {
                  href = "https://slskd.${config.domains.local}/";
                  description = "Usenet Downloader";
                  icon = "https://main.${config.domains.local}/icons/slskd.ico";
                  widget = {
                    type = "slskd";
                    url = "https://slskd.${config.domains.local}/";
                    key = "{{${to_var "slskd_key"}}}";
                  };
                };
              }
              {
                Prowlarr = {
                  href = "https://prowlarr.${config.domains.local}/";
                  description = "Indexer Manager";
                  icon = "https://main.${config.domains.local}/icons/prowlarr.svg";
                  widget = {
                    type = "prowlarr";
                    url = "https://prowlarr.${config.domains.local}/";
                    key = "{{${to_var "prowlarr_key"}}}";
                  };
                };
              }
              {
                Sonarr = {
                  href = "https://sonarr.${config.domains.local}/";
                  description = "Show Search Engine";
                  icon = "https://main.${config.domains.local}/icons/sonarr.svg";
                  widget = {
                    type = "sonarr";
                    url = "https://sonarr.${config.domains.local}/";
                    key = "{{${to_var "sonarr_key"}}}";
                  };
                };
              }
              {
                Radarr = {
                  href = "https://radarr.${config.domains.local}/";
                  description = "Movie Search Engine";
                  icon = "https://main.${config.domains.local}/icons/radarr.svg";
                  widget = {
                    type = "radarr";
                    url = "https://radarr.${config.domains.local}/";
                    key = "{{${to_var "radarr_key"}}}";
                    enableQueue = true;
                  };
                };
              }
              {
                Lidarr = {
                  href = "https://lidarr.${config.domains.local}/";
                  description = "Music Search Engine";
                  icon = "https://main.${config.domains.local}/icons/lidarr.svg";
                  widget = {
                    type = "lidarr";
                    url = "https://lidarr.${config.domains.local}/";
                    key = "{{${to_var "lidarr_key"}}}";
                  };
                };
              }
              {
                Whisparr = {
                  href = "https://whisparr.${config.domains.local}/";
                  description = "Adult Search Engine";
                  icon = "https://main.${config.domains.local}/icons/whisparr.svg";
                };
              }
              {
                AudioMuse = {
                  href = "https://audio_muse.${config.domains.local}/";
                  description = "Music Embedding Engine";
                  icon = "https://main.${config.domains.local}/icons/audiomuse.png";
                };
              }
            ];
          }
          {
            Home = [
              {
                Fitness = {
                  href = "https://fitness.${config.domains.public}/";
                  description = "Fitness and Nutrition Tracker";
                  icon = "https://main.${config.domains.local}/icons/sparkyfitness.webp";
                  widget = {
                    type = "sparkyfitness";
                    url = "https://fitness.${config.domains.public}/";
                    key = "{{${to_var "sparkyfitness_key"}}}";
                  };
                }; 
              }
              {
                HomeAssistant = {
                  href = "https://home.${config.domains.local}/";
                  description = "Smart Home";
                  icon = "https://main.${config.domains.local}/icons/homeassistant.svg";
                  widget = {
                    type = "homeassistant";
                    url = "https://home.${config.domains.local}/";
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
                  href = "https://budget.${config.domains.public}";
                  description = "Budgeting App";
                  icon = "https://main.${config.domains.local}/icons/actualbudget.svg";
                };
              }
              {
                Immich = {
                  href = "https://immich.${config.domains.public}/";
                  description = "Fotos";
                  icon = "https://main.${config.domains.local}/icons/immich.ico";
                  widget = {
                    type = "immich";
                    url = "https://immich.${config.domains.public}/";
                    key = "{{${to_var "immich_key"}}}";
                    version = 2;
                  };
                };
              }
              {
                Calendar = {
                  href = "https://calendar.${config.domains.public}";
                  description = "Calendar Web App";
                  icon = "https://main.${config.domains.local}/icons/mmdl.jpeg";
                };
              }
              {
                Baikal = {
                  href = "https://baikal.${config.domains.public}";
                  description = "Caldav Server";
                  icon = "https://main.${config.domains.local}/icons/baikal.svg";
                };
              }
              {
                ntfy = {
                  href = "https://ntfy.${config.domains.public}";
                  description = "Notification Server";
                  icon = "https://main.${config.domains.local}/icons/ntfy.svg";
                };
              }
              {
                Vaultwarden = {
                  href = "https://vaultwarden.${config.domains.public}";
                  description = "Password Manager";
                  icon = "https://main.${config.domains.local}/icons/vaultwarden.svg";
                };
              }
            ];
          }
          {
            Data = [
              {
                Notes = {
                  href = "https://notes.${config.domains.public}";
                  description = "Uni Notes";
                  icon = "https://main.${config.domains.local}/icons/obsidian.svg";
                };
              }
              {
                FileBrowser = {
                  href = "https://files.stroby.org";
                  description = "Server Files";
                  icon = "https://main.${config.domains.local}/icons/filebrowser.png";
                };
              }
              {
                Syncthing = {
                  href = "https://syncthing.${config.domains.local}/";
                  description = "Notes syncing";
                  icon = "https://main.${config.domains.local}/icons/syncthing.svg";
                };
              }
              {
                NextCloud = {
                  href = "https://cloud.stroby.org/";
                  description = "Cloude Storage";
                  icon = "https://main.${config.domains.local}/icons/nextcloud.svg";
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
