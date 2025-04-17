{ ... }:
{
  services.static-web-server = {
    enable = true;
    root = "/home/stroby/dev/kukahorizonfrontend/dist/";
    listen = "0.0.0.0:3002";
  };
  
  # Open http and https ports
  networking.firewall.allowedTCPPorts = [
    3002
  ];
}
