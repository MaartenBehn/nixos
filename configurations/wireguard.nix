{ lib, ... }:
{
  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  };
  # Enable WireGuard
  networking.wg-quick.interfaces = {
    
    dont_panic = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      address = [ "192.168.178.202/24" ];
      listenPort = 51820; # to match firewall allowedUDPPorts (without this it uses random port numbers)
      dns = [ "192.168.178.1" "fritz.box" ];

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/home/stroby/.config/wireguard/dont_panic.conf";
      
      autostart = false;

      peers = [
        # For a client configuration, one peer entry for the server will suffice.

        {
          # Public key of the server (not a file path).
          publicKey = "9GUuzV+/lezewoQCRKyjbhahGLSo5nM3ezV7utxnmhE=";

          # Forward all the traffic via VPN.
          allowedIPs = [ "192.168.178.0/24" "0.0.0.0/0" ];
          # Or forward only particular subnets
          #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

          # Set this to the server IP and port.
          endpoint = "bhiirysrb1kpua23.myfritz.net:51519";

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
