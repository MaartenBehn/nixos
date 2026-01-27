{ username, ... }:
{
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ username ];
  virtualisation.virtualbox.host.enableExtensionPack = true;

  # WARN: This causes long sysinit-reactivation.target times
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.dragAndDrop = true;
}
