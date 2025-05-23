{ pkgs, inputs, pkgs-unstable, ... }:
{
  home.packages = with pkgs; [
    inputs.nixvim.packages.x86_64-linux.default
    xclip
    lazygit
    lldb
    nodePackages.prettier
    terraform
    cargo
    rustc
    pkgs-unstable.shader-slang
  ];

  home.shellAliases = {
    nix-vim-update="cd /home/$USER/nixos/ && git add --all && nix flake update nixvim && cd -";
    nix-vim-rebuild="cd /home/$USER/nixos/ && git add --all && sudo nix flake update nixvim && sudo nixos-rebuild switch --flake ./#$NIX_TARGET --impure && cd -";
    nix-vim-config="cd ~/dev/nixvim && nvim . && cd -";
  };
}
