{ pkgs, ... }:
{
  environment.etc."nextcloud-admin-pass".text = "NextCloud+240803";
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;
    hostName = "stroby.duckdns.org";
    config.adminpassFile = "/etc/nextcloud-admin-pass";
  };
}
