{
  my.secrets.server."wireguard_mullvad_asus_private_key" = { 
    bitwarden = { name = "Wireguard Mullvad Asus"; field = "private_key"; };
    owner = "root"; 
  };

  flake.modules.nixos.server = { inputs, config, ... }: { 

    imports = [
      inputs.vpn-confinement.nixosModules.default
    ];
    
    sops.templates."wireguard/mullvad.conf" = {
      content = ''
        [Interface]
        # Device: Proper Eagle
        PrivateKey = ${config.sops.placeholder."wireguard_mullvad_asus_private_key"}
        Address = 10.71.6.130/32,fc00:bbbb:bbbb:bb01::8:681/128
        ListenPort = 51820
        DNS = 10.64.0.1

        [Peer]
        PublicKey = 7VCMEE+Oljm/qKfQJSUCOYPtRSwdOnuPyqo5Vob+GRY=
        AllowedIPs = 0.0.0.0/0,::0/0
        Endpoint = 138.199.6.207:51820
      '';
      owner = "root";
    };

    vpnNamespaces.mullvad = {
      enable = true;
      wireguardConfigFile = config.sops.templates."wireguard/mullvad.conf".path;

      accessibleFrom = [
        "192.168.0.0/24"
      ];
    };

    networking.firewall.extraCommands = ''
      # Drop any forwarded traffic to the mullvad-br network 
      # UNLESS it originated from the host's loopback interface (lo).
      iptables -I FORWARD -o mullvad-br ! -i lo -j DROP
    '';

    systemd.services."mullvad" = {
      preStart = ''
      # Purge any lingering network namespace and associated veth interfaces from previous runs
      ip netns del mullvad 2>/dev/null || true
      for iface in $(ip link show | grep -oE '[^[:space:]]+-mullvad|[[:space:]]veth[[:alnum:]_-]*'); do
        ip link delete "$iface" 2>/dev/null || true
      done
      '';
    };
  };
}

