{ pkgs, desktop, ... }:
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
      set-option -g history-limit 20000

      # For nvim 
      #set-option -sg escape-time 10
      #set-option -g default-terminal "screen-256color"
      #set-option -a terminal-features "xterm-256color:RGB"
      #set-option -g focus-events on

      set -g default-terminal 'tmux-256color'
      set -as terminal-overrides ",*-256color*:Tc"
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'
      set-option -sg escape-time 10

      # For nvim images
      set -gq allow-passthrough on
      set -g visual-activity off
      set-option -g focus-events on
    '' 
    + (if desktop == "hyprland" then ''
      # Waybar signal
      set-hook -g session-window-changed 'run-shell "pkill -SIGRTMIN+8 waybar"'
      set-hook -g alert-bell 'run-shell "pkill -SIGRTMIN+8 waybar"' 
      set-hook -g client-attached 'run-shell "pkill -SIGRTMIN+8 waybar"' 
      set-hook -g client-detached 'run-shell "pkill -SIGRTMIN+8 waybar"' 
      set-hook -g window-renamed 'run-shell "pkill -SIGRTMIN+8 waybar"' 
      set-hook -g session-created 'run-shell "pkill -SIGRTMIN+8 waybar"' 
      set-hook -g session-closed 'run-shell "pkill -SIGRTMIN+8 waybar"' 
      
      # Hiding default status
      set -g status off
    '' else ''
      # Status bar
      set -g status-right '#[fg=color15,bg=color234]  #{ram_fg_color}#{ram_percentage}#[fg=color15]  #{cpu_fg_color}#{cpu_percentage}#[fg=color15] #[fg=color15] %H:%M '
      run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
    '');


  };
}
