{ pkgs, host, ... }:
{
  home.packages = with pkgs; [
    # shell env programms
    fish
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fishPlugins.grc
    grc
    dwt1-shell-color-scripts

    # used in config
    killall
    git
  ];

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set fish_greeting # Disable greeting

      function fish_title
        set -q argv[1]; or set argv fish
        echo $argv[1];
      end

      ${if host != "asus" then ''
      #if status is-interactive 
      #and not set -q TMUX 
      #  exec tmux new -As0
      #end
      '' else ""}

      #function nix-rebuild 
      #  cd /home/$USER/nixos/
      #  command git add --all
      #  if count $argv > /dev/null
      #    command "sudo nixos-rebuild switch --impure --flake ." 
      #  else
      #    command "sudo nixos-rebuild switch --impure --flake ./#$argv[1]"  
      #  end
      #  cd -
      #end
 
      alias myip="curl http://ipecho.net/plain; echo";

      alias vpn-uni="sudo openconnect -b -u behn --authgroup=Tunnel-Uni-Bremen vpn.uni-bremen.de";
      alias vpn-kill="sudo killall openconnect";

      alias uni-vpn="vpn-uni";
      alias kill-vpn="vpn-kill";

      alias dont_panic-vpn-start="sudo systemctl start wg-quick-dont_panic.service"
      alias dont_panic-vpn-stop="sudo systemctl stop wg-quick-dont_panic.service"

      alias fritz_behns-vpn-start="sudo systemctl start wg-quick-fritz_behns.service"
      alias fritz_behns-vpn-stop="sudo systemctl stop wg-quick-fritz_behns.service"

      alias rev-tether="gnirehtet run";

      alias kill-all-background-jobs="kill -SIGKILL (jobs -lg)"

      alias link-ropelab-db="ssh -L 5432:127.0.0.1:5432 ropelab@betelgeuse.uberspace.de"

      alias minecraft_log_server_lisa="journalctl -u  minecraft-server-lisa-server.service"

      starship init fish | source
    '';
  };   
}
