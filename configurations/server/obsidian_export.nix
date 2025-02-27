{ ... }:
{
  services.static-web-server = {
    enable = true;
    root = "/home/stroby/dev/obsidian_export/quartz/public/";
    listen = "127.0.0.1:8082";
  };

  networking.firewall.allowedTCPPorts = [
    8082
  ];
}
