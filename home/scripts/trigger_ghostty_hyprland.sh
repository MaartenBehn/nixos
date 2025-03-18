#!/usr/bin/env bash

if pgrep -x ".ghostty-wrappe" > /dev/null
  then killall .ghostty-wrappe
else
  hyprctl dispatch -- exec [maximize] ghostty
fi
