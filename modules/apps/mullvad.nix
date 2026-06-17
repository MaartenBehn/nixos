{
  flake.modules.nixos.apps = { pkgs, ... }: {
    services.mullvad-vpn.enable = true;
    services.mullvad-vpn.package = pkgs.mullvad-vpn;
  };
}
