{ config, pkgs, ... }: {

  sops.secrets."wireguard/proxy/private_key" = {};

  networking.firewall = {
    trustedInterfaces = [ "proxy_wg" ];
    allowedUDPPorts = [ 51820 ];
  };

  environment.systemPackages = with pkgs; [
    iptables
  ];


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

      postSetup = [
        "iptables -t mangle -A FORWARD -o proxy_wg -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1380"
      ];
      postShutdown = [
        "iptables -t mangle -D FORWARD -o proxy_wg -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1380"
      ];
    };
  };
}
