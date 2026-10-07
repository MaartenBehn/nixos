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
            endpoint = "http://ollama.local/v1";
            model = "hermes3:8b-llama3.1-q3_K_M";

            api_key_name = "";

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
