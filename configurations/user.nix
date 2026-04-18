{ pkgs, ... }:
{
  users.users."stroby" = {
    isNormalUser = true;
    description = "stroby";
    extraGroups = [
      "networkmanager"
      "wheel"
      "media"
      "nginx"
    ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
}
