{ username, pkgs, ... }:
{
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [
      "networkmanager"
      "wheel"
      "www-data"
    ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
}
