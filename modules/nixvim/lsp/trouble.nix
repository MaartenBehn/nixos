{
  nixvimConfig = {
    plugins.trouble.enable = true;

    keymaps = [
      {
        mode = "n";
        key = "<leader>t";
        action = "<cmd>Trouble diagnostics toggle focus=true<cr>";
        options = {
          desc = "Trouble";
        };
      } 
    ];
  };
}
