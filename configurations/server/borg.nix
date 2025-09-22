{ pkgs, username, lib, config, ... }: {
  
  sops.secrets."wireguard/fritz_behns_asus_borg.conf" = { 
    owner = "stroby";  
  };

  vpnNamespaces.fritz = {
    enable = true;
    #wireguardConfigFile = config.sops.secrets."wireguard/fritz_behns_stroby.conf".path;
    wireguardConfigFile = "/home/stroby/fritz_behns_asus_borg.conf";
    namespaceAddress = "192.168.16.1";
    bridgeAddress = "192.168.16.5";
 
    accessibleFrom = [
      "192.168.0.0/24"
    ];
    openVPNPorts = [{
      port = 22;
      protocol = "both";
    }];
  };
}
