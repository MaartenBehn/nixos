{ lib, username, system, ... }:
{
  imports = [
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = username;

  nixpkgs.hostPlatform = lib.mkDefault system;

  wsl.wslConf.network.generateResolvConf = false;
  networking.nameservers = [ "8.8.8.8" ];
}
