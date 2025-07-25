{ pkgs, ... }: {
  systemd.services.jackett = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "wg";
    };

    path = with pkgs; [
      curl
      jackett
    ];
    script = "
    curl curl ipinfo.io;
    jackett;
    ";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.User = "stroby";
  };

  # Add systemd service to VPN network namespace
  systemd.services.flaresolverr.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };

  services.flaresolverr = {
    enable = true;
  };



}
