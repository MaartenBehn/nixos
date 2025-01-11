#!/bin/sh

IP=$(curl "http://ipecho.net/plain")

if [[ $IP =~ .*:.* ]]
then
  curl "https://www.duckdns.org/update?domains=stroby&token=104a071b-99cf-4b36-9948-2678fc32b1b9&ipv6=$IP&ip="
else
  curl "https://www.duckdns.org/update?domains=stroby&token=104a071b-99cf-4b36-9948-2678fc32b1b9&ip=$IP&ipv6="
fi

