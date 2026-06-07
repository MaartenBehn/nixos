/*
wg0.conf on proxy
[Interface]
Address = 10.0.0.1/24
PrivateKey = <key> 
ListenPort = 51820
MTU = 1380

PostUp = sysctl -w net.ipv4.ip_forward=1

PostUp = iptables -t nat -A POSTROUTING -o wg0 -j MASQUERADE
PostDown = iptables -t nat -D POSTROUTING -o wg0 -j MASQUERADE

PostUp = iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to-destination 10.0.0.2:80
PostDown = iptables -t nat -D PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to-destination 10.0.0.2:80

PostUp = iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 443 -j DNAT --to-destination 10.0.0.2:443
PostDown = iptables -t nat -D PREROUTING -i eth0 -p tcp --dport 443 -j DNAT --to-destination 10.0.0.2:443

PostUp = iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 25 -j DNAT --to-destination 10.0.0.2:25
PostDown = iptables -t nat -D PREROUTING -i eth0 -p tcp --dport 25 -j DNAT --to-destination 10.0.0.2:25

PostUp = iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 13470 -j DNAT --to-destination 10.0.0.2:13470
PostDown = iptables -t nat -D PREROUTING -i eth0 -p tcp --dport 13470 -j DNAT --to-destination 10.0.0.2:13470

PostUp = iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 13471 -j DNAT --to-destination 10.0.0.2:13471
PostDown = iptables -t nat -D PREROUTING -i eth0 -p tcp --dport 13471 -j DNAT --to-destination 10.0.0.2:13471

[Peer]
PublicKey = by9caER0IW6jSFfqNCD6CAN8SddjqB1GP7ylb2r6kw8=
AllowedIPs = 10.0.0.2/32


wg1.conf on proxy
[Interface]
Address = 10.1.0.1/24
PrivateKey = <new-proxy-private-key>
ListenPort = 51821

PostUp = iptables -t nat -A PREROUTING -s 10.2.0.0/24 -i wg1 -j DNAT --to-destination 10.1.0.2
PostDown = iptables -t nat -D PREROUTING -s 10.2.0.0/24 -i wg1 -j DNAT --to-destination 10.1.0.2

PostUp = iptables -t nat -A POSTROUTING -s 10.2.0.0/24 -o wg0 -j MASQUERADE
PostDown = iptables -t nat -D POSTROUTING -s 10.2.0.0/24 -o wg0 -j MASQUERADE

[Peer]
PublicKey = <phone-public-key>
AllowedIPs = 10.1.0.2/32
*/

{ lib, config, ... }: {
  options = {
    private_incoming_ip = lib.mkOption {
      type = lib.types.str;
      default = [ "10.1.0.2" ];
    };
  };

  config = {
    sops.secrets."wireguard/proxy/private_key" = {};

    networking.firewall = {
      trustedInterfaces = [ "proxy_wg" ];
      allowedUDPPorts = [ 51820 ];
    };

    networking.wireguard.interfaces = {
      proxy_wg = {
        ips = [ 
          "10.0.0.2/24" # public incoming traffic
          "${config.private_incoming_ip}/24" # traffic coming from wg1 vpn on proxy
        ];
        privateKeyFile = config.sops.secrets."wireguard/proxy/private_key".path;
        mtu = 1380;

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
  };
}
