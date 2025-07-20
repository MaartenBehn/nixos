{ ... }:
{
  services.static-web-server = {
    enable = true;
    root = "/home/stroby/dev/Gallery/Build";
    listen = "0.0.0.0:3003";
  };
}
