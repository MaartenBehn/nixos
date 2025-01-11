{ pkgs, ... }: 
{
  #Dynamic-DNS
  systemd.services.duckdns-updater = {
    path = with pkgs; [
      bash
      curl
    ];
    script = "sh /home/stroby/nixos/update_duckdns.sh";
    startAt = "hourly";  
    wantedBy = [ "network-online.target" ];
  };
  systemd.timers.duckdns-updater.timerConfig.RandomizedDelaySec = "15m";
}
