{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    extraConfig = ''
      bind-key -n S-Up new-window
      bind-key -r S-Left select-window -t :-
      bind-key -r S-Right select-window -t :+ 
      bind-key -n S-Down kill-window

      set -g status-right '#[fg=black,bg=color15]  #{ram_fg_color}#{ram_percentage}#[fg=black,bg=color15]  #{cpu_fg_color}#{cpu_percentage}#[fg=black,bg=color15]  %H:%M '
      run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
    '';

  };
}
