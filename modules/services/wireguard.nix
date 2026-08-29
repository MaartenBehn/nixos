{
  flake.modules.nixos.networking_vpn = { config, lib, pkgs, ... }: {
    sops.secrets."wireguard/private/laptop/private_key" = { owner = config.username; };
    sops.secrets."wireguard/private_local/laptop/private_key" = { owner = config.username; };
    sops.secrets."wireguard/fritz_behns_stroby/laptop/private_key" = { owner = config.username; };
    sops.secrets."wireguard/fritz_behns_stroby/laptop/preshared_key" = { owner = config.username; };

    networking.wg-quick.interfaces = {
      private = {  
        privateKeyFile = config.sops.secrets."wireguard/private/laptop/private_key".path;
        address = [ "10.1.0.3/24" "fd00:11::3/64" ];
        dns = [ "10.1.0.2" "fd00:11::2" ];

        peers = [
          {
            # proxy
            publicKey = "y/Up4Ps6jIdZHzOL2LDYnkZB3JL03MZtZmGLZXESr1U=";
            endpoint = "138.199.203.38:51821";
            allowedIPs = [ "10.1.0.0/24" "fd00:11::/64" ]; 
            persistentKeepalive = 25;
          }
        ];
        autostart = false;
      };

      private_local = {  
        privateKeyFile = config.sops.secrets."wireguard/private_local/laptop/private_key".path;
        address = [ "10.2.0.2/24" "fd00:12::2/64" ];
        dns = [ "10.1.0.2" "fd00:11::2" ];

        peers = [
          {
            # asus
            publicKey = "nX/bkTRB30KdpeDsKlw9ZjQhVSd7hGLzbnVM9exwyF4=";
            endpoint = "192.168.0.117:51823";
            allowedIPs = [ "10.1.0.0/24" "10.2.0.0/24" "fd00:11::/64" "fd00:12::/64" ];
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

    environment.systemPackages = map (name:
      pkgs.writeShellScriptBin "${name}_vpn" ''
        SERVICE="wg-quick-${name}.service"

        if systemctl is-active --quiet "$SERVICE"; then
          echo "Stopping wg-quick interface: ${name}..."
          sudo systemctl stop "$SERVICE"
        else
          echo "Starting wg-quick interface: ${name}..."
          sudo systemctl start "$SERVICE"
        fi
      ''
    ) (builtins.attrNames config.networking.wg-quick.interfaces); 

    # Allow user to stop and start vpns without sudo
    security.sudo.extraRules = [
      {
        users = [ config.username ];        
        commands = [
          {
            command = "/run/current-system/sw/bin/systemctl start wg-quick-*";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/systemctl stop wg-quick-*";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/systemctl restart wg-quick-*";
            options = [ "NOPASSWD" ];
          }
        ];      
      }
    ];
  };
}
