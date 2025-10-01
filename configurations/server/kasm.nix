{ domains, local_domain, ... }: {
  services.kasmweb = { 
    enable = true;
    listenPort = 8087;
  };

  systemd.services.kasmweb = {
    vpnConfinement = {
      enable = false;
      vpnNamespace = "mullvad";
    };
  };

  vpnNamespaces.mullvad = {
    portMappings = [
      { 
        from = 8087;
        to = 8087;
      }
    ];
  };

  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "kasm.${domain}"; 
    value = {
      enableACME = domain != local_domain;
      forceSSL = domain != local_domain;

      locations."/" = {
        #proxyPass = "http://192.168.15.1:8087/"; 
        proxyPass = "https://127.0.0.1:8087/"; 
        proxyWebsockets = true;
      };

      serverAliases = [
        "www.kasm.${domain}"
      ];
    };
  }) (domains ++ [ local_domain ]));


  /*

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
      "cmd":"bash -c '/usr/bin/desktop_ready && xfce4-terminal -T OpenVPN  -x /usr/bin/wg-quick up wg0'",
      "user":"root"
    },
    "assign": {
      "cmd": "bash -c '/dockerstartup/custom_startup.sh --assign --url \"$KASM_URL\"'"
    },
    "go": {
      "cmd": "bash -c '/dockerstartup/custom_startup.sh --go --url \"$KASM_URL\"'"
    }
  }

  */
}
