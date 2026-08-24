{
  nixvimConfig.plugins.lsp = {
    enable = true;
    servers.csharp_ls = {
      enable = true;
      settings = {
        filetypes = [
          "cs"
        ];
      };
    };
  };
}
