{ pkgs, host, ... }: {
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = if host != "asus" then pkgs.mullvad-vpn else null;
}
