{
  nixvimConfig = {
    plugins.lsp = {
      enable = true;
      servers.glsl_analyzer.enable = true;
    };

    autoGroups = {
      set_indent = {
        clear = true;
      };
    };

    autoCmd = [
      {
        group = "set_indent";
        event = [ "Filetype" ];
        pattern = [
          "glsl"
        ];
        command = "setlocal shiftwidth=4 tabstop=4";
      }
    ];
  };
}
