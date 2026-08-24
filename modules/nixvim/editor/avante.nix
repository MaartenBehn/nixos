{
  /*
  nixvimConfig = {
    plugins.avante = {
      enable = true;

      settings = {
        provider = "gemini";
        auto_suggestion_provider = "gemini";

        providers = {
          ollama = {
            endpoint = "http://127.0.0.1:11434";
            model = "deepseek-coder:1.3b"; 

            extra_request_body = {
              options = {
                num_ctx = 4096;               
                temperature = 0.2;            
              };
            };
          };
          gemini = {
            model = "gemini-3.5-flash-lite"; 
            temperature = 0;
            max_tokens = 8192;        
          };
        };
      };  
    };

    extraConfigLuaPre = ''
      local secret_path = "/run/secrets/avante_nvim/gemini_api_key"
      local f = io.open(secret_path, "r")
      if f then
        vim.env.GEMINI_API_KEY = f:read("*l"):gsub("%s+", "")
        f:close()
      end
    '';
  };
  */
}
