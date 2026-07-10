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

    # Create a native systemd service to keep LobeChat running in the background
    systemd.services.lobe-chat = {
      description = "LobeChat Native Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      # This runs the pre-compiled app instead of building it from scratch
      script = ''
    export OLLAMA_PROXY_URL="http://127.0.0.1:11434/v1"
    export PORT="8088"

    # Run the pre-bundled app globally using npx without local compilation
    ${pkgs.nodejs_20}/bin/npx @lobehub/chat
    script'';
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
