{ domains, local_domain, ... }: {
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
          ads = [
            #"https://raw.githubusercontent.com/hagezi/dns-blocklists/blob/main/adblock/ultimate.txt"
          ];
        };
        #Configure what block categories are used
        clientGroupsBlock = {
          #default = [ "ads" ];
        };
      };

      customDNS = {
        customTTL = "1h";
        mapping = builtins.listToAttrs (builtins.map (domain: {
          name = domain; 
          value = "192.168.178.2,2a00:1f:ef04:7301:3e59:650b:4c40:f405";
        }) (domains ++ [ local_domain ])) // {
            "fritz.box" = "192.168.178.1";

            # Entry's for Maddy 

          };
      };

      caching = {
        minTime = "5m";
        maxTime = "30m";
        prefetching = true;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
