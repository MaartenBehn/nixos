{ domains, local_domain, ... }: {
  services.kasmweb = { 
    enable = true;
    listenPort = 8087;
  };

  vpnNamespaces.mullvad = {
    portMappings = [
      { 
        from = 8087;
        to = 8087;
      }
    ];
  };

  web_services."kasm" = {
    domains = "local";
    loc = {
      proxyPass = "https://127.0.0.1:8087/"; 
      proxyWebsockets = true;
    };
  };
 
  /*
    # Device: Exotic Snake

  cd ~/nixos/docker/kasm/mullvad_firefox
  sudo docker build -t custom:mullvad_firefox -f Dockerfile .

  {
    "dns": [
      "194.242.2.2",
      "1.1.1.1"
    ],
    "devices": [
      "dev/net/tun",
      "/dev/net/tun"
    ],
    "user": "root",
    "privileged": true
  }

  # Docker Exec Config
  {
    "first_launch":{
      "cmd":"bash -c '/usr/bin/desktop_ready && xfce4-terminal -T wireguard -x /usr/bin/wg-quick up wg0'",
      "user":"root"
    }
  }

  */
}
