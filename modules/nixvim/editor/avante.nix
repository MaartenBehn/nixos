{
  nixvimConfig = {
    plugins.avante = {
      enable = true;

      settings = {
        provider = "ollama";
        auto_suggestion_provider = "ollama-fast";
 
        providers = {
          ollama = {
            __inherited_from = "openai";
            endpoint = "http://ollama.local/v1";
            model = "qwen2.5-coder:14b-instruct-q4_K_M";

            api_key_name = "";

            extra_request_body = {
              options = {
                num_ctx = 16384;               
                temperature = 0.0;            
              };
            };
          };
          ollama-fast = {
            __inherited_from = "openai";
            endpoint = "http://ollama.local/v1";
            model = "qwen2.5-coder:1.5b";

            api_key_name = "";

            extra_request_body = {
              options = {
                temperature = 0.2;
                max_tokens = 256;           
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
