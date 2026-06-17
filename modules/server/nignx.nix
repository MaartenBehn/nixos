{
  flake.modules.nixos.server = { lib, config, ... }:
  {
    options = {
      domains.public = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };

      domains.local = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "local" ];
      };

      domains.all = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = config.domains.public ++ config.domains.local;
      };
    };

    config = {
      security.acme = {
        acceptTerms = true;
        defaults.email = "maarten.behn@gmail.com";
      };

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
      };

    };
  };
}
