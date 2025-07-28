{ username, pkgs, ... }:
{
  users.users.${username} = {
    isNormalUser = true;
    description = username;
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
