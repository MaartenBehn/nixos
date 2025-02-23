{ pkgs, ... }:
{
  users.users.stroby.extraGroups = [ "docker" ];
  virtualisation.docker.enable = false;

  environment.systemPackages = with pkgs; [
    lazydocker
  ];
}
