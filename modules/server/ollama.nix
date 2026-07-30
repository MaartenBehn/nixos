{
  flake.modules.nixos.server_ollama = {
    zramSwap = {
      enable = true;
      memoryPercent = 50; # Creates ~2GB compressed swap in RAM
    };

    services.ollama = {
      enable = true;
      acceleration = false;       
      loadModels = [ "qwen2-vl:2b" ];

      environmentVariables = {
        OLLAMA_MAX_LOADED_MODELS = "1";
        OLLAMA_NUM_PARALLEL = "1";
        OLLAMA_KEEP_ALIVE = "5m"; # Unloads model after 5m of inactivity to free RAM
      };
    };

    services.open-webui = {
      enable = true;

      host = "0.0.0.0";
      port = 8088; 

      environment = {
        OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
        WEBUI_AUTH = "true";      
      };
    };

    web_services."ai" = {
      domains = "all";
      root = {
        proxyPass = "http://127.0.0.1:8088/"; 
        proxyWebsockets = true;    

        extraConfig = ''
          proxy_read_timeout 300s;
          proxy_connect_timeout 300s;
          proxy_send_timeout 300s;
        '';
      };
    };
  };

  flake.modules.nixos.ollama_dev = {
    services.ollama = {
      enable = true;
      loadModels = [ "qwen2.5-coder:1.5b-base" ];
      environmentVariables = {
        OLLAMA_NUM_THREADS = "16";
      };
    };
  };
}

