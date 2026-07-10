{
  flake.modules.nixos.server = { pkgs, ... }: {
    services.ollama = {
      enable = true;
      acceleration = "rocm"; # cuda (nvidia) or rocm (amd)
      loadModels = [ "llama3.2:3b" "qwen2.5-coder:1.5b" ];
    };

    environment.systemPackages = with pkgs; [
      nodejs_20
    ];

    services.librechat = {
      enable = true;
      host = "127.0.0.1";
      port = 8088;

      # Automatically sets up and manages a local MongoDB instance for user/chat storage
      enableLocalDB = true; 

      # Server configuration environment variables
      settings = {
        # Points straight to your local native Ollama instance
        OLLAMA_BASE_URL = "http://127.0.0.1:11434";

        # Restricts the UI to only show your local models
        OLLAMA_MODELS = "llama3.2:3b,qwen2.5-coder:1.5b";

        # Helpful default flags
        TITLE_CONVO = "true";
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
