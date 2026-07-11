{ inputs, ... }: {
  flake.modules.nixos.server = { pkgs-unstable, ... }: {
    services.ollama = {
      enable = true;
      acceleration = "rocm"; # cuda (nvidia) or rocm (amd)
      loadModels = [ "llama3.2:3b" "deepseek-coder:1.3b" ];
    };

    imports = [
      "${inputs.nixpkgs-unstable}/nixos/modules/services/web-apps/librechat.nix"
    ];

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
}
