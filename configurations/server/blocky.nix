{ ... }: {
  services.blocky = {
    enable = true;
    settings = {
      ports.dns = 53; # Port for incoming DNS Queries.
      upstreams.groups.default = [
        "https://one.one.one.one/dns-query" # Using Cloudflare's DNS over HTTPS server for resolving queries.
      ];
      # For initially solving DoH/DoT Requests when no system Resolver is available.
      bootstrapDns = {
        upstream = "https://one.one.one.one/dns-query";
        ips = [ "1.1.1.1" "1.0.0.1" ];
      };
      #Enable blocking of certain domains.
      blocking = {
        blackLists = {
          #Adblocking
          ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
          #Another filter for blocking adult sites
          adult = ["https://blocklistproject.github.io/Lists/porn.txt"];
          #You can add additional categories
        };
        #Configure what block categories are used
        clientGroupsBlock = {
          default = [ "ads" ];
          kids-ipad = ["ads" "adult"];
        };
      };

      customDNS = {
        customTTL = "1h";
        mapping = {
          "home" = "192.168.178.3,2a00:1f:ef04:7301:3e59:650b:4c40:f405";
          "stroby.duckdns.org" = "192.168.178.3,2a00:1f:ef04:7301:3e59:650b:4c40:f405";
          "stroby.ipv64.de" = "192.168.178.3,2a00:1f:ef04:7301:3e59:650b:4c40:f405";
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
