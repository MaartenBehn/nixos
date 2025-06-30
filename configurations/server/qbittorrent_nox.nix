{ pkgs, ... }: {
  systemd.services.qbittorrent-nox = {
    path = with pkgs; [
      qbittorrent-nox
    ];
    script = "qbittorrent-nox";
    wantedBy = [ "multi-user.target" ];
		after = [ "network-online.target" "nss-lookup.target" ];
    serviceConfig.User = "stroby";
  };
}
