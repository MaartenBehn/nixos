{
  my.secrets.server.acme_cloudflare_api = { 
    bitwarden = { name = "Cloudflare"; field = "asus_acme_token"; };
  };

  flake.modules.nixos.server = { config, lib, pkgs, ... }: 
    lib.mkIf (config.domains.public != null) (let 
      all_domains = lib.filter (d: d != null) [ config.domains.public config.domains.local ];
      wildcard_domains = map (d: "*.${d}") all_domains;
    in {
      security.acme = {
        acceptTerms = true;
        defaults.email = "maarten.behn@gmail.com";

        certs.${config.domains.public} = {
          domain = config.domains.public;
          extraDomainNames = wildcard_domains;
          dnsProvider = "cloudflare";
          environmentFile = config.sops.templates."acme.env".path;
          dnsResolver = "1.1.1.1:53";
          group = "acme";
        };
      };

      sops.templates."acme.env" = {
        content = ''
          CLOUDFLARE_DNS_API_TOKEN=${config.sops.placeholder.acme_cloudflare_api}
        '';
      };

      users.users.nginx.extraGroups = [ "acme" ];
    });
}
