{
  flake.modules.nixos.apps = { pkgs, ... }: {
    #services.mullvad-vpn.enable = true;
    #services.mullvad-vpn.gui.enable = true;
  };
}
