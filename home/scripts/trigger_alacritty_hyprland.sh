#!/usr/bin/env bash

if pgrep -x "alacritty" > /dev/null
  then killall alacritty
else
  hyprctl dispatch -- exec [maximize] alacritty
fi
