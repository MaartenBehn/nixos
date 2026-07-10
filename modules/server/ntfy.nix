{
  flake.modules.nixos.server = {
    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://ntfy.stroby.org";
        listen-http = ":8090";
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
