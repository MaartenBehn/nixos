{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    inputs.nixvim.packages.x86_64-linux.default
    xclip
    lazygit
    lldb
    nodePackages.prettier
    terraform
  ];
}
