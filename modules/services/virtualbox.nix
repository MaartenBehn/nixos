{
  flake.modules.nixos.virtualbox = { config, ... }: {
    virtualisation.virtualbox.host.enable = true;
    users.extraGroups.vboxusers.members = [ config.username ];
    virtualisation.virtualbox.host.enableExtensionPack = true;

    # WARN: This causes long sysinit-reactivation.target times
    virtualisation.virtualbox.guest.enable = true;
    virtualisation.virtualbox.guest.dragAndDrop = true;
  };
}
