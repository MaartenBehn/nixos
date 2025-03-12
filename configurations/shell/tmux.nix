{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    extraConfig = ''
      bind-key -n S-Up new-window -c "#{pane_current_path}"
      bind-key -n S-Left select-window -t :-
      bind-key -n S-Right select-window -t :+ 
      bind-key -n S-Down kill-window

      # Enable scrolling
      set -g mouse on
      set -ga terminal-overrides ',*256color*:smcup@:rmcup@'

      # For nvim 
      set-option -sg escape-time 10
      set-option -g default-terminal "screen-256color"
      set-option -a terminal-features "xterm-256color:RGB"
      set-option -g focus-events on

      set -g @batt_remain_short true
      set -g status-right '#[fg=color15,bg=color234]  #{ram_fg_color}#{ram_percentage}#[fg=color15]  #{cpu_fg_color}#{cpu_percentage}#[fg=color15] 󰁹 #{battery_color_charge_fg}#{battery_percentage}  #[fg=color15] %H:%M '
      run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
      run-shell ${pkgs.tmuxPlugins.battery}/share/tmux-plugins/battery/battery.tmux
    '';

  };
}
