{ config, ... }: {

  sops.secrets."wireguard/proxy/private_key" = {};

  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.wireguard.interfaces = {
    proxy_wg = {
      ips = [ "10.0.0.2/24" ];
      privateKeyFile = config.sops.secrets."wireguard/proxy/private_key".path;

      peers = [
        {
          publicKey = "DpmJigVkK0f+wK7PRWymhxouBAIrqrVdArpMdPTuOkk=";
          endpoint = "138.199.203.38:51820";
          allowedIPs = [ "10.0.0.0/24" ];
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
