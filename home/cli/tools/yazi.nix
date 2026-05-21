{ pkgs, ... }: {
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      yazi = {
        ratio = [
          1
          4
          3
        ];
        sort_by = "natural";
        sort_sensitive = true;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "none";
        show_hidden = true;
        show_symlink = true;
        extraPackages = with pkgs; [
          lazygit
          fd
          _7zz
        ];
      };

      preview = {
        image_filter = "lanczos3";
        image_quality = 90;
        tab_size = 1;
        max_width = 600;
        max_height = 900;
        ueberzug_scale = 1;
        ueberzug_offset = [
          0
          0
          0
          0
        ];
      };

      tasks = {
        micro_workers = 5;
        macro_workers = 10;
        bizarre_retry = 5;
      };
    };

    keymap = {
      #input.prepend_keymap = [
      #{ run = "close"; on = [ "<C-q>" ]; }
      #{ run = "close --submit"; on = [ "<Enter>" ]; }
      #{ run = "escape"; on = [ "<Esc>" ]; }
      #{ run = "backspace"; on = [ "<Backspace>" ]; }
      #];
      mgr.prepend_keymap = [
        #{ run = "escape"; on = [ "<Esc>" ]; }
        #{ run = "quit"; on = [ "q" ]; }
        #{ run = "close"; on = [ "<C-q>" ]; }

        { on = [ "g" "i" ]; run = "plugin lazygit"; desc = "run lazygit"; }
        { on = [ "M" ]; run = "plugin mount"; desc = "show mount"; }
        { on = [ "c" "a" ]; run = "plugin compress"; desc = "Archive selected files"; }
      ];
    };

    plugins = {
      inherit (pkgs.yaziPlugins) mount;
      inherit (pkgs.yaziPlugins) compress;
      inherit (pkgs.yaziPlugins) lazygit;
    };
  };
}
