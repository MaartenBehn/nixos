{
  flake.modules.nixos.server = { inputs, config, ... }: { 

    imports = [
      inputs.vpn-confinement.nixosModules.default
    ];

    sops.secrets."wireguard/mullvad/asus/private_key" = { owner = "root"; };
    sops.secrets."wireguard/mullvad.conf" = { owner = "root"; };

    sops.templates."wireguard/mullvad.conf" = {
      content = ''
        [Interface]
        # Device: Proper Eagle
        PrivateKey = ${config.sops.placeholder."wireguard/mullvad/asus/private_key"}
        Address = 10.71.6.130/32,fc00:bbbb:bbbb:bb01::8:681/128
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
      wireguardConfigFile = config.sops.secrets."wireguard/mullvad.conf".path;

      accessibleFrom = [
        "192.168.0.0/24"
      ];
    };
  };
}

