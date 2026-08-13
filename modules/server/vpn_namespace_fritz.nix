{
  flake.modules.nixos.server = { inputs, config, pkgs, ... }: 
  let 
    check_fritz_vpn = pkgs.writeShellScriptBin "check_fritz_vpn" ''
      ping -c 2 192.168.178.39 || (systemctl restart fritz.service && sleep 10) 
    ''; 
  in { 

    imports = [
      inputs.vpn-confinement.nixosModules.default
    ];

    sops.secrets."wireguard/fritz_behns_asus_borg/asus/private_key" = { owner = "root"; };
    sops.secrets."wireguard/fritz_behns_asus_borg/asus/preshared_key" = { owner = "root"; };

    sops.templates."wireguard/fritz_behns_asus_borg.conf" = {
      content = ''
        [Interface]
        PrivateKey = ${config.sops.placeholder."wireguard/fritz_behns_asus_borg/asus/private_key"}
        Address = 192.168.178.202/24,fdf5:5527:63fc::202/64
        ListenPort = 51821
        DNS = 192.168.178.1,fdf5:5527:63fc::9a9b:cbff:feba:47e9

        [Peer]
        PublicKey = mrcEyPu/E0HKqmpazQRj7baIKHnqAKic4SuT6DI59BQ=
        PresharedKey = ${config.sops.placeholder."wireguard/fritz_behns_asus_borg/asus/preshared_key"}
        AllowedIPs = 192.168.178.0/24,0.0.0.0/0,fdf5:5527:63fc::/64,::/0
        Endpoint = u73237za9dqn7w2w.myfritz.net:53021
        PersistentKeepalive = 25
      '';
      owner = "root";
    };

    vpnNamespaces.fritz = {
      enable = true;
      wireguardConfigFile = config.sops.templates."wireguard/fritz_behns_asus_borg.conf".path;
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
        inetutils
        check_fritz_vpn
      ];
      script = "check_fritz_vpn";
    };
  };
}

