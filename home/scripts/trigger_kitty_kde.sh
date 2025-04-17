#!/bin/sh

if pgrep -x ".kitty-wrapped" > /dev/null
  then killall .kitty-wrapped
else
  kitty
fi

