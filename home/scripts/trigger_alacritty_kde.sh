#!/bin/sh

if pgrep -x "alacritty" > /dev/null
  then killall alacritty
else
  alacritty
fi

