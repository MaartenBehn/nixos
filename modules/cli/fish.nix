{
  flake.modules.nixos.cli = { pkgs, config, ... }: {
    users.users."${config.username}".shell = pkgs.fish;
    programs.fish.enable = true;
  };

  flake.modules.homeManager.cli = { pkgs, config, ... }: {
    home.packages = with pkgs; [
      grc
      dwt1-shell-color-scripts
      killall
      git
    ];

    programs.fish = {
      enable = true;

      plugins = [
        { name = "done"; src = pkgs.fishPlugins.done.src; }
        { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
        { name = "forgit"; src = pkgs.fishPlugins.forgit.src; }
        { name = "hydro"; src = pkgs.fishPlugins.hydro.src; }
        { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      ];

      shellAliases = {
        myip = "curl http://ipecho.net/plain; echo";
        vpn-uni = "sudo openconnect -b -u behn --authgroup=Tunnel-Uni-Bremen vpn.uni-bremen.de";
        vpn-kill = "sudo killall openconnect";
        uni-vpn = "vpn-uni";
        kill-vpn = "vpn-kill";
        rev-tether = "gnirehtet run";
        kill-all-background-jobs = "kill -SIGKILL (jobs -lg)";
      };

      interactiveShellInit = ''
        set fish_greeting # Disable greeting

        ${if config.wayland.windowManager.hyprland.enable then ''
        if test -z "$WAYLAND_DISPLAY" -a (tty) = "/dev/tty1" 
          exec start-hyprland 
        end
        '' else ""}

        function fish_title
          set -q argv[1]; or set argv fish
          echo $argv[1];
        end
      '' + ''
        # Keep starship at the very bottom so it doesn't interfere with core initializations
        starship init fish | source
      '';
    };    
  };}
