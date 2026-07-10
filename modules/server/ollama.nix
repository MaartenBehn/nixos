{ inputs, ... }: {
  flake.modules.nixos.server = { pkgs-unstable, ... }: {
    services.ollama = {
      enable = true;
      acceleration = "rocm"; # cuda (nvidia) or rocm (amd)
      loadModels = [ "llama3.2:3b" "qwen2.5-coder:1.5b" ];
    };

    imports = [
      "${inputs.nixpkgs-unstable}/nixos/modules/services/web-apps/librechat.nix"
    ];

    services.librechat = {
      enable = true;
      package = pkgs-unstable.librechat;
      env = {
        PORT = 8088;
        env = {
        # You can replace these strings with 32-byte hex keys later if desired
        CREDS_KEY = "f34ebd568e61298a8a9947c9451bcff5f34ebd568e61298a8a9947c9451bcff5";
        CREDS_IV = "a34ebd568e61298a8a9947c9451bcff5";
        JWT_SECRET = "super_secret_jwt_string_change_me_in_production";
        JWT_REFRESH_SECRET = "super_secret_jwt_refresh_string_change_me_in_production";
      };

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
