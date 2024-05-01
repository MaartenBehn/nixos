let
  user = "stroby";
in
{
  users.users.syncthing.extraGroups = [ "users" ];
  users.users."${user}".extraGroups = [ "syncthing" ];
  systemd.services.syncthing.serviceConfig.UMask = "0007";
  systemd.tmpfiles.rules = [
    "d /home/${user} 0750 alan syncthing"
  ];
}
