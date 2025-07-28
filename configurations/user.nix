{ username, pkgs, ... }:
{
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [
      "networkmanager"
      "wheel"
      "media"
    ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
}
