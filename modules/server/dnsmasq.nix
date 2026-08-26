{
  flake.modules.nixos.server = { config, lib, ... }: {
    services.dnsmasq = {
      enable = true;
      settings = {
        interface = [ "tunnel_wg" "local_wg" ];
        bind-interfaces = true;
        listen-address = [ "10.1.0.2" "10.2.0.1" "fd00:11::2" "fd00:12::1" ];

        domain-needed = true;
        bogus-priv = true;

        # Don't forward any of the local domains to upstream DNS
        local = map (domain: "/${domain}/") config.domains.local;

        # Resolve *.{domain} → VPN IP for every local domain
        address = lib.flatten (map (domain: [ 
          "/.${domain}/10.1.0.2" 
          "/.${domain}/fd00:11::2" 
        ]) config.domains.all);
      };
    };

    services.resolved.extraConfig = ''
      DNSStubListener=no
    '';
  };
}
