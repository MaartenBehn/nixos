{
  nixvimConfig = {
    plugins.auto-save = {
      enable = true;
      settings = {
        write_all_buffers = true;
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>ma";
        action = "<cmd>ASToggle<CR>";
        options = {
          desc = "Toggle Auto Save";
        };
      }
    ];
  };
}
