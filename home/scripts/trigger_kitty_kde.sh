#!/usr/bin/env bash

if pgrep -x ".kitty-wrapped" > /dev/null
  then killall .kitty-wrapped
else
  kitty
fi

