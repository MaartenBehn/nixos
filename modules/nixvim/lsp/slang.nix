{
  nixvimConfig = { pkgs, ... }: {
    plugins.lsp = {
      enable = true;
      servers.slangd = {
        package = pkgs.shader-slang;
        enable = true;
      };
    };
  };
}
