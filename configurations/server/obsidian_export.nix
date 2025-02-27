{ ... }:
{
  services.static-web-server = {
    enable = true;
    root = "/home/stroby/dev/obsidian_export/quartz/public/";
    listen = "0.0.0.0:8082";
  };

  networking.firewall.allowedTCPPorts = [
    8082
  ];
}
