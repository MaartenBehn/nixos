{ pkgs, config, ... }:
{
  imports = [
  "${fetchTarball {
    url = "https://github.com/onny/nixos-nextcloud-testumgebung/archive/fa6f062830b4bc3cedb9694c1dbf01d5fdf775ac.tar.gz";
    sha256 = "0gzd0276b8da3ykapgqks2zhsqdv4jjvbv97dsxg0hgrhb74z0fs";}}/nextcloud-extras.nix"
  ];

  environment.etc."nextcloud-admin-pass".text = "Nextcloud+240803";
  environment.etc."nextcloud-stroby-pass".text = "Nextcloud+240803";

  security.acme = {
    acceptTerms = true;   
    defaults.email = "stroby241@gmail.com";
  };
 
  services = {
    nginx.virtualHosts = {
       "cloud.stroby.duckdns.org" = {
         forceSSL = true;
         enableACME = true;
       };

      #"onlyoffice.stroby.duckdns.org" = {
      #  forceSSL = true;
      #  enableACME = true;
      #};
    };

    nextcloud = {
      enable = true;
      hostName = "cloud.stroby.duckdns.org";

       # Need to manually increment with every major upgrade.
      package = pkgs.nextcloud28;
      
      # Let NixOS install and configure Redis caching automatically.
      configureRedis = true;

      # Increase the maximum file upload size to avoid problems uploading videos.
      maxUploadSize = "16G";
      https = true;

      autoUpdateApps.enable = true;
      # extraAppsEnable = true;
      #extraApps = with config.services.nextcloud.package.packages.apps; {
        # List of apps we want to install and are already packaged in
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
      # inherit calendar contacts mail notes onlyoffice tasks;

        # Custom app installation example.
      # cookbook = pkgs.fetchNextcloudApp rec {
      #   url =
      #     "https://github.com/nextcloud/cookbook/releases/download/v0.10.2/Cookbook-0.10.2.tar.gz";
      #   sha256 = "sha256-XgBwUr26qW6wvqhrnhhhhcN4wkI+eXDHnNSm1HDbP6M=";
      # };
      #};

      settings = {
        overwriteprotocol = "https";
        default_phone_region = "de";
      };

      config = {
        adminpassFile = "/etc/nextcloud-admin-pass";
        adminuser = "root";
        dbtype = "sqlite";
      };

      ensureUsers = {
        stroby = {
          email = "maarten.behn@gmail.com";
          passwordFile = "/etc/nextcloud-stroby-pass";
      } ;
      };
    };

    #onlyoffice = {
    #  enable = true;
    #  hostname = "onlyoffice.stroby.duckdns.org";
    #};
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  }; 
}
