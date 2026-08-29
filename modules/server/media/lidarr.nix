{
  flake.modules.nixos.server = { pkgs, pkgs-unstable, ... }: 
    let 
      # Local build from plugins branch
      plugin_branch = pkgs-unstable.lidarr.overrideAttrs (old: {
        version = "plugins"; # usually harmless to omit

        src = pkgs.fetchFromGitHub {
          owner = "Lidarr";
          repo = "Lidarr";
          rev = "e42a7ca4fd633e021d69da7daa0368b870b0282e";
          hash = "sha256-vjLoMU7Ow9rFFcZjCUvqoKZnrmg3TeB8Cqh1nSF8shM=";
        };
      });
      # https://github.com/blampe/hearring-aid/blob/main/docs/self-hosted-mirror-setup.md#101-configure-tubifarry-plugin-in-lidarr

      # Local build from plugins branch
      latest = pkgs.lidarr.overrideAttrs (old: {
        version = "v3.1.0.4875";
      });

    in {

      users.groups.media.members = [ "lidarr" ];

      services.lidarr = { 
        enable = true;
        openFirewall = false;
        #package = pkgs.lidarr;
        package = plugin_branch;
        # package = latest;
      };

      systemd.services.lidarr = {
        vpnConfinement = {
          enable = true;
          vpnNamespace = "mullvad";
        };

        # For youtube download plugin
        path = [
          pkgs-unstable.ffmpeg
          pkgs-unstable.nodejs
        ];

        # Declaratively download and extract Tubifarry before Lidarr starts
        preStart = let
          tubifarryZip = pkgs.fetchurl {
            url = "https://github.com/TypNull/Tubifarry/releases/download/v2.2.0.4/Tubifarry-v2.2.0.4.net8.0.zip";
            # Calculate hash with: nix-prefetch-url https://github.com/TypNull/Tubifarry/releases/download/v2.2.0.4/Tubifarry-v2.2.0.4.net8.0.zip
            hash = "sha256-1b5cbe3ecff19fa3acbe555e5464a4cd74c9912faaa986ab8ec37dc63dd27e9b=";
          };
        in ''
          TARGET_DIR="/var/lib/lidarr/plugins/TypNull/Tubifarry"
          mkdir -p "$TARGET_DIR"
          ${pkgs.unzip}/bin/unzip -o ${tubifarryZip} -d "$TARGET_DIR"
        '';
      };

      vpnNamespaces.mullvad = {
        portMappings = [
          { 
            from = 8686;
            to = 8686;
          }
        ];
      };

      web_services."lidarr" = {
        domains = "local";
        root = {
          proxyPass = "http://192.168.15.1:8686/"; 
        };
      };
    };
}
