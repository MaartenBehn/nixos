{ pkgs, ... }: {
  systemd.services.filebrowser = {
    path = with pkgs; [
      filebrowser
      getent
    ];
    script = "filebrowser --address 127.0.0.1 --port 8089 --database /home/stroby/filebrowser.db";
    wantedBy = [ "network-online.target" ];
		after = [ "network.target" ];
  };

  web_services."files".loc.proxyPass = "http://127.0.0.1:8089/"; 
}


