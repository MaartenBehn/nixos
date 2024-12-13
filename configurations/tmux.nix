{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    extraConfig = ''
      bind-key -n S-Up new-window
      bind-key -n S-Left next-window
      bind-key -n S-Right last-window
      bind-key -n S-Down kill-window

      set -g status-right '#[fg=black,bg=color15]  #{ram_fg_color}#{ram_percentage}#[fg=black,bg=color15]  #{cpu_fg_color}#{cpu_percentage}#[fg=black,bg=color15]  %H:%M '
      run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
    '';

  };
}
