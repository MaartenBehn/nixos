{
  flake.modules.nixos.networking_vpn = { config, lib, pkgs, ... }: {
    sops.secrets."wireguard/private/laptop/private_key" = { owner = "stroby"; };
    sops.secrets."wireguard/private_local/laptop/private_key" = { owner = "stroby"; };
    sops.secrets."wireguard/fritz_behns_stroby/laptop/private_key" = { owner = "stroby"; };
    sops.secrets."wireguard/fritz_behns_stroby/laptop/preshared_key" = { owner = "stroby"; };

    networking.wg-quick.interfaces = {
      private = {  
        privateKeyFile = config.sops.secrets."wireguard/private/laptop/private_key".path;
        address = [ "10.1.0.3/24" ];
        dns = [ "10.1.0.2" ];

        peers = [
          {
            publicKey = "y/Up4Ps6jIdZHzOL2LDYnkZB3JL03MZtZmGLZXESr1U=";
            endpoint = "138.199.203.38:51821";
            allowedIPs = [ "10.1.0.0/24" ]; 
            persistentKeepalive = 25;
          }
        ];
        autostart = false;
      };

      private_local = {  
        privateKeyFile = config.sops.secrets."wireguard/private/laptop/private_key".path;
        address = [ "10.2.0.2/24" ];
        dns = [ "10.2.0.1" ];

        peers = [
          {
            publicKey = "y/Up4Ps6jIdZHzOL2LDYnkZB3JL03MZtZmGLZXESr1U=";
            endpoint = "192.168.0.117:51821";
            allowedIPs = [ "10.2.0.0/24" "10.1.0.0/24" ];
            persistentKeepalive = 25;
          }
        ];
        autostart = false;
      };

      fritz_behns = {  
        privateKeyFile = config.sops.secrets."wireguard/fritz_behns_stroby/laptop/private_key".path;
        address = [ "192.168.178.201/24" ];
        listenPort = 51820;
        dns = [ "192.168.178.1" "fritz.box" ];

        peers = [
          {
            publicKey = "mrcEyPu/E0HKqmpazQRj7baIKHnqAKic4SuT6DI59BQ=";
            presharedKeyFile = config.sops.secrets."wireguard/fritz_behns_stroby/laptop/preshared_key".path;
            endpoint = "u73237za9dqn7w2w.myfritz.net:53021";
            allowedIPs = [ "192.168.178.0/24" "0.0.0.0/0" ];
            persistentKeepalive = 25;
          }
        ];
        autostart = false;
      };
    };

    environment.systemPackages = lib.flatten (
      map (name: [
        (pkgs.writeShellScriptBin "${name}_vpn_u" ''
        echo "Starting wg-quick interface: ${name}..."
        sudo systemctl start wg-quick-${name}.service
        '')
        (pkgs.writeShellScriptBin "${name}_vpn_d" ''
        echo "Stopping wg-quick interface: ${name}..."
        sudo systemctl stop wg-quick-${name}.service
        '')
      ]) (builtins.attrNames config.networking.wg-quick.interfaces)
    );
  };
}
