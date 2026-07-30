/*
                   ┌─────────┐          tunnel           ┌────────┐                
                   │  proxy  │ ───────────────────────── │  asus  │                
       private     │         │                           │        │   private_local
    ┌────────────► ┼─────────┼─────────────────────────► │        │ ◄──────────┐   
    │  10.1.0.1    │         │               10.1.0.2    │        │ 10.2.0.1   │   
    │  fd00:11::2  │         │               fd00:11::2  │        │ fd00:12::1 │   
    │              │         │                           │        │            │   
    │              │         │ ───────────────────────── │        │            │   
    │              └─────────┘  10.0.0.1     10.0.0.2    └────────┘            │   
    │                           fd00:10::1   fd00:10::2                        │   
    │                                                                          │   
    │                                                                          │   
    │                                ┌──────────┐                              │   
    ├──────────────────────────────► │  laptop  │ ◄────────────────────────────┤   
    │                    10.1.0.3    │          │  10.2.0.2                    │   
    │                    fd00:11::3  └──────────┘  fd00:12::2                  │   
    │                                                                          │   
    │                                ┌──────────┐                              │   
    └──────────────────────────────► │  phone   │ ◄────────────────────────────┘   
                         10.1.0.4    │          │  10.2.0.3                        
                         fd00:11::4  └──────────┘  fd00:12::3 


wg0.conf on proxy

[Interface]
Address = 10.0.0.1/24, fd00:10::1/64
PrivateKey = <key> 
ListenPort = 51820
MTU = 1380

PostUp = sysctl -w net.ipv4.ip_forward=1
PostUp = sysctl -w net.ipv6.conf.all.forwarding=1

PostUp = iptables -t nat -A POSTROUTING -o wg0 -j MASQUERADE
PostUp = iptables -t nat -A PREROUTING -i eth0 -p tcp -m multiport --dports 25,80,443,13470,13471 -j DNAT --to-destination 10.0.0.2

PostDown = iptables -t nat -D POSTROUTING -o wg0 -j MASQUERADE || true
PostDown = iptables -t nat -D PREROUTING -i eth0 -p tcp -m multiport --dports 25,80,443,13470,13471 -j DNAT --to-destination 10.0.0.2

PostUp = ip6tables -t nat -A POSTROUTING -o wg0 -j MASQUERADE
PostUp = ip6tables -t nat -A PREROUTING -i eth0 -p tcp -m multiport --dports 25,80,443,13470,13471 -j DNAT --to-destination [fd00:10::2]

PostDown = ip6tables -t nat -D POSTROUTING -o wg0 -j MASQUERADE || true
PostDown = ip6tables -t nat -D PREROUTING -i eth0 -p tcp -m multiport --dports 25,80,443,13470,13471 -j DNAT --to-destination [fd00:10::2]

# asus
[Peer]
PublicKey = by9caER0IW6jSFfqNCD6CAN8SddjqB1GP7ylb2r6kw8=
AllowedIPs = 10.0.0.2/32, 10.1.0.2/32, fd00:10::2/128, fd00:11::2/128


wg1.conf on proxy

[Interface]
Address = 10.1.0.1/24, fd00:11::1/64
PrivateKey = <key>
ListenPort = 51821

PostUp = ip route add 10.1.0.2/32 dev wg0
PostDown = ip route del 10.1.0.2/32 dev wg0 || true

PostUp = ip -6 route add fd00:11::2/128 dev wg0
PostDown = ip -6 route del fd00:11::2/128 dev wg0 || true

PostUp = iptables -t nat -A POSTROUTING -s 10.1.0.0/24 -o wg0 -j MASQUERADE
PostDown = iptables -t nat -D POSTROUTING -s 10.1.0.0/24 -o wg0 -j MASQUERADE || true

PostUp = ip6tables -t nat -A POSTROUTING -s fd00:11::/64 -o wg0 -j MASQUERADE
PostDown = ip6tables -t nat -D POSTROUTING -s fd00:11::/64 -o wg0 -j MASQUERADE || true

# laptop 
[Peer]
PublicKey = +8tnywj+wDGQz8mkJE/9eECh2QBLy7yJwoQpQ6sgsBk=
AllowedIPs = 10.1.0.3/32, fd00:11::3/128

      
*/

{
  flake.modules.nixos.server = { config, ... }: {

    sops.secrets = {
      "wireguard/tunnel/asus/private_key" = {};
      "wireguard/private_local/asus/private_key" = {};
    };

    networking.firewall = {
      trustedInterfaces = [ "tunnel_wg" "local_wg" ];
      allowedUDPPorts = [ 51820 51821 ];
    };

    networking.wireguard.interfaces = {
      tunnel_wg = {
        ips = [ 
          # public incoming traffic
          "10.0.0.2/24"           
          "fd00:10::2/64"

          # traffic coming from wg1 vpn on proxy
          "10.1.0.2/24"        
          "fd00:11::2/64"
        ];
        privateKeyFile = config.sops.secrets."wireguard/tunnel/asus/private_key".path;
        mtu = 1380;

        peers = [
          {
            # proxy
            publicKey = "DpmJigVkK0f+wK7PRWymhxouBAIrqrVdArpMdPTuOkk=";
            endpoint = "138.199.203.38:51820";
            allowedIPs = [ "10.0.0.0/24" "10.1.0.0/24" "fd00:10::/64" "fd00:11::/64" ];
            persistentKeepalive = 25;
          }
        ];
      };

      local_wg = {
        ips = [ "10.2.0.1/24" "fd00:12::1/64" ];
        listenPort = 51821;
        privateKeyFile = config.sops.secrets."wireguard/private_local/asus/private_key".path;

        peers = [
          {
            # laptop
            publicKey = "+8tnywj+wDGQz8mkJE/9eECh2QBLy7yJwoQpQ6sgsBk=";
            allowedIPs = [ "10.2.0.2/32" "fd00:12::2/128" ];
          }
        ];
      };
    };
  };
}
