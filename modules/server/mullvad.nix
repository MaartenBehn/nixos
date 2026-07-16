{
  flake.modules.nixos.server = { inputs, config, ... }: { 

    imports = [
      inputs.vpn-confinement.nixosModules.default
    ];

    sops.secrets."wireguard/mullvad.conf" = { owner = "root"; };

    vpnNamespaces.mullvad = {
      enable = true;
      wireguardConfigFile = config.sops.secrets."wireguard/mullvad.conf".path;

      accessibleFrom = [
        "192.168.0.0/24"
      ];
    };
  };
}

