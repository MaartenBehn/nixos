#!/usr/bin/env bash

if pgrep -x ".kitty-wrapped" > /dev/null
  then killall .kitty-wrapped
else
  hyprctl dispatch -- exec [maximize] kitty
fi
