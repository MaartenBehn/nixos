#!/bin/sh

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


