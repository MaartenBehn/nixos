{ lib, ... }:

{
  imports = [
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  wsl.wslConf.network.generateResolvConf = false;
  networking.nameservers = [ "8.8.8.8" ];
}
