{ pkgs, domains, local_domain, host, ... }: {
  systemd.services.filebrowser = {
    path = with pkgs; [
      filebrowser
      getent
    ];
    script = "filebrowser --address 127.0.0.1 --database /home/stroby/filebrowser.db";
    wantedBy = [ "network-online.target" ];
		after = [ "network.target" ];
  };

  web_services."files".loc.proxyPass = "http://127.0.0.1:8080/"; 
}


