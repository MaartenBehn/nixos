{ inputs, pkgs, ... }: 
let 
  check_fritz_vpn = pkgs.writeShellScriptBin "check_fritz_vpn" ''
    ping 192.168.178.39 || (systemctl restart fritz.service && sleep 10) 
  ''; 
in {
 
  # Important: 
  # To read files from an other group the group has the specified in the config 
  # giving the borg user the group does not work!

  imports = [
    inputs.vpn-confinement.nixosModules.default
    ./error_notify.nix
  ];

  sops.secrets."wireguard/fritz_behns_asus_borg.conf" = { 
    owner = "borg";  
  };

  users.users.borg = {
    isNormalUser = true;
  };

  # borg users ~/.ssh/id_ed25519.pub must be added to authorized_key in DiskStation
  # https://blog.aaronlenoir.com/2018/05/06/ssh-into-synology-nas-with-ssh-key/
  vpnNamespaces.fritz = {
    enable = true;
    #wireguardConfigFile = config.sops.secrets."wireguard/fritz_behns_stroby.conf".path;
    wireguardConfigFile = "/home/borg/fritz_behns_asus_borg.conf";
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

  systemd.services.fritz_behns_vpn_check = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "fritz";
    };

    serviceConfig.Type = "oneshot";
    
    path = with pkgs; [
      check_fritz_vpn
    ];
    script = "check_fritz_vpn";
  };

}
