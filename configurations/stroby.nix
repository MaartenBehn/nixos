{ ... }:
{
  users.users.stroby = {
    isNormalUser = true;
    description = "stroby";
    extraGroups = [
      "networkmanager"
      "wheel"
      "www-data"
    ];
  };

}
