{
  nixvimConfig = {
    opts = {
      spell = false;
      spelllang = [ 
        "en"
        "de"
      ];
      spellsuggest = "fast,5";
    };

    autoGroups = {
      spell_check = { };
    };

    autoCmd = [
      {
        group = "spell_check";
        event = [ "Filetype" ];
        pattern = [
          "typst"
          "md"
        ];
        command = "setlocal spell";
      }
    ];

    keymaps = [
      {
        mode = "n";
        key = "<leader>s";
        action = "<cmd>lua require('telescope.builtin').spell_suggest(require('telescope.themes').get_cursor({}))<cr>";
        options = {
          desc = "Spell Suggestions";
        };
      }
    ];
  };
}
