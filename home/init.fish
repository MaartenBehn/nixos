set fish_greeting # Disable greeting

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

alias nix-rebuild-="cd /home/$USER/nixos/ && git add -all && sudo nixos-rebuild switch --flake . --impure && cd -";
alias nix-rebuild-nh="sudo echo 'Got root access' && cd /home/$USER/nixos/ && git add --all && nh os switch . -- --impure && cd -";
alias nix-rebuild-pull="cd /home/$USER/nixos/ && git pull && sudo nixos-rebuild switch --flake . --impure && cd -";
alias iso-nix-build="nix build .#nixosConfigurations.iso.config.system.build.isoImage";
      
alias nix-vim-update="cd /home/$USER/nixos/ && git add --all && nix flake update nixvim && cd -"
alias nix-vim-rebuild="cd /home/$USER/nixos/ && git add --all && sudo nix flake update nixvim && sudo nixos-rebuild switch --flake ./#$NIX_TARGET --impure && cd -";
      
alias nix-update="cd /home/$USER/nixos/ && git add --all && nix flake update && cd -"
alias nix-clean="sudo nix-collect-garbage --delete-older-than 30d && nix-store --optimise"
alias nix-index="sh /home/$USER/nixos/update_nix_index.sh"
alias nix-store-size="du -BM /nix/store/ | sort -n"
function nix-search-local -d "find /nix -name <NAME>"
  find /nix -name $argv[1]
end

# Edit Configs
alias nix-config="cd ~/nixos && nvim . && cd -"
alias nix-vim-config="cd ~/dev/nixvim && nvim . && cd -"

alias ls="exa -l -a";
alias ping="ping -c 5";

alias lgit="lazygit";
alias lg="lazygit";

alias myip="curl http://ipecho.net/plain; echo";

alias vpn-uni="sudo openconnect -b -u behn --authgroup=Tunnel-Uni-Bremen vpn.uni-bremen.de";
alias vpn-kill="sudo killall openconnect";

alias uni-vpn="vpn-uni";
alias kill-vpn="vpn-kill";

alias dont_panic-vpn-start="sudo systemctl start wg-quick-dont_panic.service"
alias dont_panic-vpn-stop="sudo systemctl stop wg-quick-dont_panic.service"

alias fritz_behns-vpn-start="sudo systemctl start wg-quick-fritz_behns.service"
alias fritz_behns-vpn-stop="sudo systemctl stop wg-quick-fritz_behns.service"

alias fritz_behns_asus-vpn-start="sudo systemctl start wg-quick-fritz_behns_asus.service"
alias fritz_behns_asus-vpn-stop="sudo systemctl stop wg-quick-fritz_behns_asus.service"

alias rev-tether="gnirehtet run";

# Nix Shell
alias nix-shell-init="rm .envrc || true && echo 'use nix' >> .envrc && direnv allow"
alias init-nix-shell=nix-shell-init
alias init-shell=nix-shell-init
alias load_shell="direnv reload"
export DIRENV_LOG_FORMAT=""

alias kill-all-background-jobs="kill -SIGKILL (jobs -lg)"

alias link-ropelab-db="ssh -L 5432:127.0.0.1:5432 ropelab@betelgeuse.uberspace.de"

alias minecraft_log_server_lisa="journalctl -u  minecraft-server-lisa-server.service"

# Stuff for creating ISO 
alias iso-find-drive="sudo fdisk -l";

function iso-write-to-drive -d "iso-write-to-drive <sdx> <.iso file>"
  du -BM $argv[2]
  sudo dd bs=4M if=$argv[2] of=/dev/$argv[1] status=progress oflag=sync
end
