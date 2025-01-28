{ pkgs, ... }: {
  systemd.services.filebrowser = {
    path = with pkgs; [
      filebrowser
    ];
    script = "filebrowser --address 0.0.0.0 --database /home/stroby/filebrowser.db";
    wantedBy = [ "network-online.target" ];
		after = [ "network.target" ];
  };

  networking.firewall = {
    allowedTCPPorts = [ 8080 ];
    allowedUDPPorts = [ 8080 ];
  };
}
