{
  flake.modules.nixos.server = {
    services.ntfy-sh = {
      enable = true;
      openFirewall = false;
      settings = {
        base-url = "https://ntfy.stroby.org";
        listen-http = "127.0.0.1:8090";
      };
    };

    web_services."ntfy" = {
      domains = "all";
      root = {
        proxyPass = "http://127.0.0.1:8090/"; 
        proxyWebsockets = true; 
      };
    }; 
  };
}
