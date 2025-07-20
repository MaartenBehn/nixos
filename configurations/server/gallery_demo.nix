{ ... }:
{
  services.static-web-server = {
    enable = true;
    root = "/home/stroby/dev/Gallery/Build";
    listen = "127.0.0.1:8084";
  };
}
