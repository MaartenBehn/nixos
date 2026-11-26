{
  flake.modules.nixos.docker = { pkgs, ... }:
  {
    users.users.stroby.extraGroups = [ "docker" ];
    virtualisation.docker.enable = true;

    environment.systemPackages = with pkgs; [
      lazydocker
    ];
  };
}
