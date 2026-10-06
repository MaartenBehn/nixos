{
  nixvimConfig = {
    plugins.avante = {
      enable = true;

      settings = {
        provider = "ollama";
        auto_suggestion_provider = "ollama";

        providers = {
          ollama = {
            __inherited_from = "openai";
            endpoint = "http://ollama.local";
            model = "qwen2.5-coder:7b"; 

            extra_request_body = {
              options = {
                num_ctx = 16384;               
                temperature = 0.0;            
              };
            };
          };
          /*gemini = {
            model = "gemini-3.5-flash-lite"; 
            temperature = 0;
            max_tokens = 8192;        
          };*/
        };
      };  
    };
  };
}
