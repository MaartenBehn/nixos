{ lib, ... }:

{
  imports = [
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = "stroby";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
