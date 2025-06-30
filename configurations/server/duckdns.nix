{ pkgs, username, ... }: 
let 
  update_duckdns = pkgs.writeShellScriptBin "update_duckdns" ''
#!/usr/bin/env bash

sleep 10

IP4=$(curl "http://v4.ident.me")

if [[ $IP4 =~ [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]
then
  curl "https://www.duckdns.org/update?domains=stroby&token=104a071b-99cf-4b36-9948-2678fc32b1b9&ip=$IP4"
else
  echo "No IPV4: $IP4"
fi

IP6=$(curl "http://v6.ident.me")

if [[ $IP6 =~ .*:.* ]]
then
  curl "https://www.duckdns.org/update?domains=stroby&token=104a071b-99cf-4b36-9948-2678fc32b1b9&ipv6=$IP6"
else
  echo "No IPV6: $IP6"
fi
  '';


in {
  systemd.services.duckdns-updater = {
    path = with pkgs; [
      bash
      curl
      update_duckdns
    ];
    script = "update_duckdns";
    startAt = "hourly";  
    wantedBy = [ "network-online.target" ];
  };
  systemd.timers.duckdns-updater.timerConfig.RandomizedDelaySec = "15m";
}
