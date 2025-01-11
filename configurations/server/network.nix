{ pkgs, ... }:
{
  imports = [
    "./ssh.nix"
    "./static_ip.nix"
  ];

  environment.systemPackages = with pkgs; [
    networkmanager
  ];
}
