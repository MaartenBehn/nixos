{ pkgs, host, lib, ... }:
{
  boot.loader.systemd-boot.enable = host != "wsl";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.supportedFilesystems = [ "ntfs" ];

  boot.loader.timeout = lib.mkDefault 15;
}
