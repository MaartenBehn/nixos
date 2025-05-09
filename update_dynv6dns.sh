#!/bin/sh -e
hostname="stroby.dynv6.net"
token="hBc-xW_m83JR6oG1tZJPd3b8MPsjiz"
device=
file=$HOME/.dynv6.addr6
bin="curl -fsS"

sleep 10

[ -e $file ] && old=`cat $file`

if [ -z "$hostname" -o -z "$token" ]; then
  echo "Usage: token=<your-authentication-token> [netmask=64] $0 your-name.dynv6.net [device]"
  exit 1
fi

if [ -z "$netmask" ]; then
  netmask=128
fi

if [ -n "$device" ]; then
  device="dev $device"
fi
address=$(ip -6 addr list scope global $device | grep -v " fd" | sed -n 's/.*inet6 \([0-9a-f:]\+\).*/\1/p' | head -n 1)

if [ -z "$address" ]; then
  echo "no IPv6 address found"
  exit 1
fi

# address with netmask
current=$address/$netmask

if [ "$old" = "$current" ]; then
  echo "IPv6 address unchanged"
  exit
fi

# send addresses to dynv6
$bin "http://dynv6.com/api/update?hostname=$hostname&ipv6=$current&token=$token"
$bin "http://ipv4.dynv6.com/api/update?hostname=$hostname&ipv4=auto&token=$token"

# save current address
echo $current > $file

