{ pkgs, ... }: 
{
  #Dynamic-DNS
  systemd.services.duckdns-updater = {
      path = with pkgs; [
        bash
        curl
      ];
      script = "sh /home/stroby/nixos/update_dynv6dns.sh";
      startAt = "hourly";   
  };
  systemd.timers.duckdns-updater.timerConfig.RandomizedDelaySec = "15m";
}
