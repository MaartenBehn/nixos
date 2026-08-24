{
  /*
  nixvimConfig.plugins = {
    cmp-ai = {
      enable = true;
      settings = {
        provider = "Ollama";

        provider_options = {
          model = "qwen2.5-coder:1.5b-base";
          endpoint = "http://127.0.0.1:11434";

          prompt.__raw = "function(lines_before, lines_after) return lines_before end";
          suffix.__raw = "function(lines_after) return lines_after end";
        };

        run_on_every_keystroke = false;
        max_lines = 30;       

        options = {
          temperature = 0.0; # 0.0 forces the absolute most deterministic/accurate code choice
          max_tokens = 40;   # Keeps completions to 1-3 lines max (perfect for immediate popup suggestions)
          stop = [
            "```"
            "\n\n"
            "Note:"
            "Explanation:"
            "Here is"
            "<｜begin▁of▁sentence｜>"
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
  */
}
