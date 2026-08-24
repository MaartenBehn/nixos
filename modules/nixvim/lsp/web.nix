{
  nixvimConfig.plugins.lsp = {
    enable = true;
    servers = {
      ts_ls.enable = true;
      html.enable = true;
    };
  };
}
