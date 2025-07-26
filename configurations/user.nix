{ username, pkgs, ... }:
{
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [
      "networkmanager"
      "wheel"
      "www-data"
      "media"
    ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
}
