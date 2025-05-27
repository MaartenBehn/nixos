{ lib, username, system, inputs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  wsl.enable = true;
  wsl.defaultUser = username;

  nixpkgs.hostPlatform = lib.mkDefault system;

  wsl.wslConf.network.generateResolvConf = false;
}
