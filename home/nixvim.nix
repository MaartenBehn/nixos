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
}
