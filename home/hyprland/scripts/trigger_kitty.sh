#!/usr/bin/env bash

PID=$(hyprctl clients -j | jq '.[] | select(.class=="kitty_main") | .pid')

if [ -z "${PID}" ];
then 
  hyprctl dispatch -- exec [maximize] 'kitty --class kitty_main' 
else
  kill $PID
fi
