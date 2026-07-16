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

    sops.secrets."wireguard/fritz_behns_asus_borg.conf" = { owner = "root"; };

    vpnNamespaces.fritz = {
      enable = true;
      wireguardConfigFile = config.sops.secrets."wireguard/fritz_behns_asus_borg.conf".path;
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

