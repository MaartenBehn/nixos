{
  nixvimConfig = {
    plugins.lsp = {
      enable = true;
      servers.clangd.enable = true;
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
        pattern = [ "c" "h" "cpp" "hpp" ];
        command = "setlocal shiftwidth=4 tabstop=4";
      }
    ];
  };
}
