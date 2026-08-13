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
PostUp = ip6tables -t nat -A POSTROUTING -o wg0 -j MASQUERADE

PostUp = iptables -t nat -A PREROUTING -i eth0 -p tcp -m multiport --dports 80,443 -j DNAT --to-destination 10.0.0.2
PostUp = ip6tables -t nat -A PREROUTING -i eth0 -p tcp -m multiport --dports 80,443 -j DNAT --to-destination [fd00:10::2]

PostDown = iptables -t nat -D POSTROUTING -o wg0 -j MASQUERADE || true
PostDown = ip6tables -t nat -D POSTROUTING -o wg0 -j MASQUERADE || true

PostDown = iptables -t nat -D PREROUTING -i eth0 -p tcp -m multiport --dports 80,443 -j DNAT --to-destination 10.0.0.2 || true
PostDown = ip6tables -t nat -D PREROUTING -i eth0 -p tcp -m multiport --dports 80,443 -j DNAT --to-destination [fd00:10::2] || true

# asus
[Peer]
PublicKey = by9caER0IW6jSFfqNCD6CAN8SddjqB1GP7ylb2r6kw8=
AllowedIPs = 10.0.0.2/32, 10.1.0.2/32, fd00:10::2/128, fd00:11::2/128
PersistentKeepalive = 25


wg1.conf on proxy

[Interface]
Address = 10.1.0.1/24, fd00:11::1/64
PrivateKey = <key>
ListenPort = 51821

# laptop 
[Peer]
PublicKey = +8tnywj+wDGQz8mkJE/9eECh2QBLy7yJwoQpQ6sgsBk=
AllowedIPs = 10.1.0.3/32, fd00:11::3/128
PersistentKeepalive = 25

# phone
[Peer]
PublicKey = LyvcC36v0jZrStd2YnWIFB7iTc0ujwtDlr5C6xYGpQk=
AllowedIPs = 10.1.0.4/32, fd00:11::4/128
PersistentKeepalive = 25
      
*/

{
  flake.modules.nixos.server = { config, ... }: {

    sops.secrets = {
      "wireguard/tunnel/asus/private_key" = {};
      "wireguard/private_local/asus/private_key" = {};
    };

    networking.firewall = {
      trustedInterfaces = [ "tunnel_wg" "local_wg" ];
      allowedUDPPorts = [ 51821 51822 ];
    };

    networking.wireguard.interfaces = {
      tunnel_wg = {
        ips = [ 
          # public incoming traffic
          "10.0.0.2/32"           
          "fd00:10::2/128"

          # traffic coming from wg1 vpn on proxy
          "10.1.0.2/32"        
          "fd00:11::2/128"
        ];
        listenPort = 51822;
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
        listenPort = 51823;
        privateKeyFile = config.sops.secrets."wireguard/private_local/asus/private_key".path;

        peers = [
          {
            # laptop
            publicKey = "rcFazibB7nshttMzpY8TIgGHgwFuXkky8+E/zG4knS8=";
            allowedIPs = [ "10.2.0.2/32" "fd00:12::2/128" ];
            persistentKeepalive = 25;
          }
          {
            # phone
            publicKey = "MkVmp26gVpD+weCXVRGpcF0B6z6V5lkjmZzfuxDCRn4=";
            allowedIPs = [ "10.2.0.3/32" "fd00:12::3/128" ];
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
}
