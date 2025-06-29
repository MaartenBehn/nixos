{ pkgs, ... }:
{
   home.packages = with pkgs; [
    # nix cli
    nix-index
    nix-du
    nix-search-cli
    nh
    
    direnv
    nix-prefetch-github

    ## Used in aliases 
    fd
  ];

  # Base Nix tools
  programs.command-not-found.enable = false;
  programs.nix-index.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
  };
  
  home.shellAliases = {
    nix-rebuild="cd /home/$USER/nixos/ && git add --all && sudo nixos-rebuild switch --flake . --impure && cd -";
    nix-rebuild-nh="sudo echo 'Got root access' && cd /home/$USER/nixos/ && git add --all && nh os switch . -- --impure && cd -";
    nix-rebuild-pull="cd /home/$USER/nixos/ && git pull && sudo nixos-rebuild switch --flake . --impure && cd -";

    nix-update="cd /home/$USER/nixos/ && git add --all && nix flake update && cd -";
    nix-clean="sudo nix-collect-garbage --delete-older-than 30d && nix-store --optimise";
    nix-index="sh /home/$USER/nixos/update_nix_index.sh";
    nix-store-size="du -BM /nix/store/ | sort -n";
    nix-search-local = "fd /nix";

    nix-config="cd ~/nixos && nvim . && cd -";

    nix-shell-init="rm .envrc || true && echo 'use nix' >> .envrc && direnv allow";
    nix-devshell-init="rm .envrc || true && echo 'use flake' >> .envrc && direnv allow";
    init-nix-shell="nix-shell-init";
    init-shell="nix-shell-init";
    load_shell="direnv reload";
  };
}
