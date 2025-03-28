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

      # Waybar signal
      set-hook -g session-window-changed 'run-shell "pkill -SIGRTMIN+8 waybar"'
      set-hook -g alert-bell 'run-shell "pkill -SIGRTMIN+8 waybar"' 
      set-hook -g client-attached 'run-shell "pkill -SIGRTMIN+8 waybar"' 
      
      # Hiding default status
      set -g status off
     
      # Old status bar
      # set -g status-right '#[fg=color15,bg=color234]  #{ram_fg_color}#{ram_percentage}#[fg=color15]  #{cpu_fg_color}#{cpu_percentage}#[fg=color15] #[fg=color15] %H:%M '
      # run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
    '';

  };
}
