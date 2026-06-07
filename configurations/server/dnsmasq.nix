{ config, ... }:
{
  services.dnsmasq = {
    enable = true;
    settings = {
      interface = "proxy_wg";
      bind-interfaces = true;
      listen-address = config.private_incoming_ip;

      domain-needed = true;
      bogus-priv = true;

      # Don't forward any of the local domains to upstream DNS
      local = map (domain: "/${domain}/") config.domains.local;

      # Resolve *.{domain} → VPN IP for every local domain
      address = map (domain: "/.${domain}/${config.private_incoming_ip}") config.domains.local;
    };
  };

  services.resolved.extraConfig = ''
    DNSStubListener=no
  '';
}
