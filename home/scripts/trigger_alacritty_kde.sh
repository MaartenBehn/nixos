#!/usr/bin/env bash

if pgrep -x "alacritty" > /dev/null
  then killall alacritty
else
  alacritty
fi

