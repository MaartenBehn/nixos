{ ... }: {
  services.xserver.enable = true;
  services.xserver.desktopManager.kodi.enable = true;
  services.displayManager.autoLogin.user = "stroby";
  services.xserver.displayManager.lightdm.greeter.enable = false;

  web_services."kodi" = {
    domains = "all";
    loc = {
      proxyPass = "http://127.0.0.1:8080/";
      proxyWebsockets = true;
    };
  };
}
