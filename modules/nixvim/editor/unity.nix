{
  nixvimConfig = { pkgs, ... }: {
    extraPlugins = [ pkgs.vimPlugins.nvim-unity ];

    #extraConfigLua = "require('nvim-unity').setup({foo = "bar"})"
  };
}
