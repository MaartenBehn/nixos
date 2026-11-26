{
  flake.modules.nixos.server_ollama = { pkgs, config, ... }: {
    zramSwap = {
      enable = true;
      memoryPercent = 50; # Creates ~2GB compressed swap in RAM
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;

      # Ensures Vulkan driver ICDs are generated system-wide
      extraPackages = with pkgs; [
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer
      ];
    };

    services.ollama = {
      enable = true;
      acceleration = "vulkan";       
      loadModels = [ ];

      environmentVariables = {
        LD_LIBRARY_PATH = "/run/opengl-driver/lib:${config.hardware.nvidia.package}/lib";
        OLLAMA_FLASH_ATTENTION = "0";
        OLLAMA_MAX_LOADED_MODELS = "1";
        OLLAMA_NUM_PARALLEL = "1";
        OLLAMA_KEEP_ALIVE = "5m"; # Unloads model after 5m of inactivity to free RAM
        OLLAMA_CONTEXT_LENGTH="16384";
        OLLAMA_GPU_OVERHEAD = "250000000";
        OLLAMA_DEBUG = "1";
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

    web_services."ollama" = {
      domains = "all";
      root = {
        proxyPass = "http://127.0.0.1:11434"; 
        proxyWebsockets = true;    

        extraConfig = ''
          proxy_read_timeout 300s;
          proxy_connect_timeout 300s;
          proxy_send_timeout 300s;
        '';
      };
    };

    web_services."ai" = {
      domains = "all";
      root = {
        proxyPass = "http://127.0.0.1:8088/"; 
        proxyWebsockets = true;    

        extraConfig = ''
          proxy_read_timeout 1800s;
          proxy_connect_timeout 1800s;
          proxy_send_timeout 1800s;
          send_timeout 1800s;
        '';
      };
    };
  };
}
