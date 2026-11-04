{
  flake.modules.nixos.server_base = { lib, config, ... }:
    {
      # Open http and https ports
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];
      networking.firewall.allowedUDPPorts = [
        80
        443
      ];

      services.nginx = {
        enable = true;
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;

        # Block all other domains on wildcard 0.0.0.0
        virtualHosts."_" = {
          default = true;
          rejectSSL = true;
          locations."/" = {
            return = "444";
          };
        };

        # Block unmatched domains on VPN interfaces instead of falling back to the first vhost
        virtualHosts."_vpn" = {
          listenAddresses = [ "10.1.0.2" "10.2.0.1" "[fd00:11::2]" "[fd00:12::1]" ];
          default = true;
          rejectSSL = true;
          locations."/" = {
            return = "444";
          };
        };
      };
    };
}
