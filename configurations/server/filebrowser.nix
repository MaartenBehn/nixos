{ pkgs, ... }: {
  systemd.services.filebrowser = {
    path = with pkgs; [
      filebrowser
    ];
    script = "filebrowser --address 0.0.0.0";
    wantedBy = [ "network-online.target" ];
		after = [ "network.target" ];
    serviceConfig.User = "stroby";
  };
}
