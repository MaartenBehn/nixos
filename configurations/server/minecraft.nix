{ pkgs, lib, inputs, ... }:
{
  # https://github.com/Infinidoge/nix-minecraft?tab=readme-ov-file

  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  networking.firewall = {
    allowedTCPPorts = [ 
      13470 
      13471
    ];
  };

  services.minecraft-servers = {
    enable = true;
    eula = true;
    
    servers = {
      vanilla-world = {
        enable = true;
        package = pkgs.fabricServers.fabric-1_21_4;

        jvmOpts = "-Djava.net.preferIPV4stack=false -Djava.net.preferIPv6Addresses=true";

        serverProperties = {
          gamemode = "survival";
          difficulty = "normal";
          level-seed = "7644964991330705060"; #https://www.rockpapershotgun.com/best-minecraft-seeds-java-survival-seeds#cherry-valley

          enforce-secure-profile = false;
          simulation-distance = 10;
          view-distance = 32;
          motd = "Stroby's und Lisa's Fichten Dorf";
          spawn-protection = 0;
          white-list = true;
          enforce-white-list = true;
          server-port = 13470;
        };

        whitelist = {
          Stroby_MC = "aad8a1da-f616-4dbb-a76c-d2c8ff8ca032";
          EineBekannte = "c4aff99a-fd96-48e1-a3de-78a007c33318";
        };

        files."ops.json" = {
          value = [
            {     
              uuid = "aad8a1da-f616-4dbb-a76c-d2c8ff8ca032"; 
              name = "Stroby_MC";
              level = 4;
            }
          ];
        }; 
      };

      sky-block = {
        enable = false;
        package = pkgs.fabricServers.fabric-1_21_4;

        jvmOpts = "-Djava.net.preferIPV4stack=false -Djava.net.preferIPv6Addresses=true";

        serverProperties = {
          gamemode = "survival";
          difficulty = "normal";
          # level-seed = "7644964991330705060"; #https://www.rockpapershotgun.com/best-minecraft-seeds-java-survival-seeds#cherry-valley

          enforce-secure-profile = false;
          simulation-distance = 10;
          view-distance = 32;
          motd = "Stroby's und Lisa's Fliegende Inseln";
          spawn-protection = 0;
          white-list = true;
          enforce-white-list = true;
          server-port = 13471;
        };

        whitelist = {
          Stroby_MC = "aad8a1da-f616-4dbb-a76c-d2c8ff8ca032";
          EineBekannte = "c4aff99a-fd96-48e1-a3de-78a007c33318";
        };

        files."ops.json" = {
          value = [
            {     
              uuid = "aad8a1da-f616-4dbb-a76c-d2c8ff8ca032"; 
              name = "Stroby_MC";
              level = 4;
            }
          ];
        }; 
      };
    };
  };
}
