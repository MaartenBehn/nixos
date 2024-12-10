{ ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting

      alias nix-rebuild="cd /home/stroby/nixos/ && git add --all && sudo nixos-rebuild switch --flake ./#$TARGET --impure && cd -";
      alias nix-update="cd /home/stroby/nixos/ && git add --all && nix flake update && cd -"
      alias nix-clean="sudo nix-collect-garbage --delete-older-than 30d && nix-store --optimise"
      alias nix-index="sh /home/stroby/nixos/update_nix_index.sh"
      alias nix-store-size="du -BM /nix/store/ | sort -n"
      alias nix-search-local="find /nix -name '$1'"

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
      export DIRENV_LOG_FORMAT=""

      alias kill-all-background-jobs="kill -SIGKILL (jobs -lg)"

      alias link-ropelab-db="ssh -L 5432:127.0.0.1:5432 ropelab@betelgeuse.uberspace.de"

      starship init fish | source
    '';
  };
  programs.nix-index.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Maarten Behn";
    userEmail = "maarten.behn@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      merge.tool = "meld";
    };
  };

  programs.ssh.enable = true;
  programs.ssh.matchBlocks = {
    ropelab = {
      hostname = "betelgeuse.uberspace.de";
      user = "ropelab";
    };
    behnserver = {
      hostname = "192.168.178.39";
      user = "Stroby";
    };
  };
}
