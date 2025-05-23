#!/usr/bin/env bash

IP=$(curl http://ipecho.net/plain)
if [[ $IP =~ .*:.* ]]
then
  echo "IP is V6: $IP -> starting vpn"
  systemctl start wg-quick-fritz_behns.service
else
  echo "IP is V4: $IP no need to connect via vpn."
fi
