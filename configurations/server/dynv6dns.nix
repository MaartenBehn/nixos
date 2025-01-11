{ pkgs, ... }: 
{
  #Dynamic-DNS
  systemd.services.dynv6dns-updater = {
      path = with pkgs; [
        bash
        curl
        iproute2 
      ];
      script = "sh /home/stroby/nixos/update_dynv6dns.sh";
      startAt = "hourly";   
      wantedBy = [ "network-online.target" ];
  };
  systemd.timers.duckdns-updater.timerConfig.RandomizedDelaySec = "15m";
}
