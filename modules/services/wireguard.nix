{
  flake.modules.nixos.networking_vpn = { config, ... }: {
      networking.firewall = {
      #allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
      };

      sops.secrets."wireguard/private.conf" = { owner = "stroby"; };
      sops.secrets."wireguard/private_local.conf" = { owner = "stroby"; };
      sops.secrets."wireguard/dont_panic.conf" = { owner = "stroby"; };
      sops.secrets."wireguard/fritz_behns_stroby.conf" = { owner = "stroby"; };
      
      sops.secrets."wireguard/private/laptop/private_key" = { owner = "stroby"; };
      sops.secrets."wireguard/private_local/laptop/private_key" = { owner = "stroby"; };

    networking.wg-quick.interfaces = {

      private = {  
        privateKeyFile = config.sops.secrets."wireguard/private/laptop/private_key".path;
        ips = [ "10.1.0.3/24" ];
        dns = "10.1.0.2";

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
        ips = [ "10.2.0.2/24" ];
        dns = "10.2.0.1";

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
          autostart = false;
          configFile = config.sops.secrets."wireguard/fritz_behns_stroby.conf".path;
        };   
      };
    };
}
