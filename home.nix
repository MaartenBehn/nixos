{ config, pkgs, lib, ... }:

{
  programs.home-manager.enable = true;

  home.username = "stroby";
  home.homeDirectory = "/home/stroby";
  home.stateVersion = "23.11";

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting

      alias update="cd /home/stroby/nixos/ && git add --all && git commit -m "rebuild" && git push && sudo nixos-rebuild switch --flake ~/nixos/#default --impure && cd -";
      alias clean="sudo nix-collect-garbage --delete-older-than 30d" 
      alias upd=update
      alias ls="exa -l -a";
      alias ping="ping -c 5";

      alias myip="curl http://ipecho.net/plain; echo";

      alias vpn-uni="sudo openconnect -b -u behn --authgroup=Tunnel-Uni-Bremen vpn.uni-bremen.de";
      alias vpn-kill="sudo killall openconnect";

      alias uni-vpn="vpn-uni";
      alias kill-vpn="vpn-kill";

      alias rev-tether="gnirehtet run";
    
      # Nix Shell
      alias nix-shell-init="rm .envrc || true && echo 'use nix' >> .envrc && direnv allow"
      alias init-nix-shell=nix-shell-init
      alias init-shell=nix-shell-init
      alias load_shell="direnv reload"
      export DIRENV_LOG_FORMAT= 

      starship init fish | source
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

   programs.git = {
    enable = true;
    userName  = "Maarten Behn";
    userEmail = "maarten.behn@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}

