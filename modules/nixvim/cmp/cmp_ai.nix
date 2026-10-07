{
  nixvimConfig.plugins = {
    cmp-ai = {
      enable = true;
      settings = {
        provider = "Ollama";
        log_errors = true;

        provider_options = {
          model = "qwen2.5-coder:1.5b";
          base_url = "http://ollama.local/api/generate";

          prompt.__raw = "function(lines_before, lines_after) return lines_before end";
          suffix.__raw = "function(lines_after) return lines_after end";
        };

        run_on_every_keystroke = true;
        max_lines = 30;      
        notify = true;
        notify_callback.__raw = "function(msg) vim.notify(msg)end";

        options = {
          temperature = 0.0;          
          num_predict = 40;
          stop = [
            "<fim prefix>"
            "<fim suffix>"
            "<fim middle>"
            "<|endoftext|>"
            "\n\n"
          ];        
        };      
      };
    };

    cmp = {
      settings = {
        mapping = {
          "<C-g>" = ''
            cmp.mapping(function(fallback)
              cmp.complete({
                config = {
                  sources = {
                    { name = 'cmp_ai' }
                  }
                }
              })
            end, { 'i', 's' })
          '';
        };
      };
    };
  };
}
