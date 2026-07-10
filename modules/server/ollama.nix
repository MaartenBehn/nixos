{
  flake.modules.nixos.server = {
    services.ollama = {
      enable = true;
      acceleration = "rocm"; # cuda (nvidia) or rocm (amd)
      loadModels = [ "llama3.2:3b" "qwen2.5-coder:1.5b" ];
    };

    services.open-webui = {
      enable = true;

      host = "127.0.0.1";
      port = 8088; 

      environment = {
        OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
        WEBUI_AUTH = "true";
      };
    };

    web_services."ai" = {
      domains = "all";
      root = {
        proxyPass = "http://http://127.0.0.1:8088/"; 
        proxyWebsockets = true;    

        extraConfig = ''
          proxy_read_timeout 300s;
          proxy_connect_timeout 300s;
          proxy_send_timeout 300s;
        '';
      };
    };
  };
}
