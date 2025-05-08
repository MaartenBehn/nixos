#!/usr/bin/env bash
if [ $# -eq 0 ]; then
    echo "No arg of: home, dlr, present, mirror-all"
    exit
fi

swaync-client -cp

hyprctl keyword monitor DP-1,disable
hyprctl keyword monitor DP-2,disable
hyprctl keyword monitor DP-3,disable
hyprctl keyword monitor DP-4,disable
hyprctl keyword monitor DP-5,disable
hyprctl keyword monitor DP-6,disable
hyprctl keyword monitor DP-7,disable
hyprctl keyword monitor DP-8,disable
hyprctl keyword monitor DP-9,disable
hyprctl keyword monitor DP-10,disable
hyprctl keyword monitor DP-11,disable

sleep 0.5

if [ "$1" == "present" ]; then
  hyprctl keyword monitor DP-3,2256x1504,auto,1
  hyprctl keyword monitor eDP-1,highres,auto,1,mirror,DP-3

  hyprctl keyword workspace 1, monitor:eDP-1, default:true 
  hyprctl keyword workspace [2-15], monitor:eDP-1

elif [ "$1" == "mirror-all" ]; then
  hyprctl keyword monitor eDP-1,2256x1504,0x0,1
  hyprctl keyword monitor DP-1,highres,auto,1,mirror,eDP-1
  hyprctl keyword monitor DP-2,highres,auto,1,mirror,eDP-1
  hyprctl keyword monitor DP-3,highres,auto,1,mirror,eDP-1
  hyprctl keyword monitor DP-4,highres,auto,1,mirror,eDP-1
  hyprctl keyword monitor DP-5,highres,auto,1,mirror,eDP-1
  hyprctl keyword monitor DP-6,highres,auto,1,mirror,eDP-1
  hyprctl keyword monitor DP-7,highres,auto,1,mirror,eDP-1
  hyprctl keyword monitor DP-8,highres,auto,1,mirror,eDP-1
  hyprctl keyword monitor DP-9,highres,auto,1,mirror,eDP-1
  hyprctl keyword monitor DP-10,highres,auto,1,mirror,eDP-1
  hyprctl keyword monitor DP-11,highres,auto,1,mirror,eDP-1

  hyprctl keyword workspace 1, monitor:eDP-1, default:true 
  hyprctl keyword workspace [2-15], monitor:eDP-1

elif [ "$1" == "home" ]; then
  hyprctl keyword monitor eDP-1,2256x1504,0x0,1
  hyprctl keyword monitor DP-5,1920x1080,-1920x0,1
  hyprctl keyword monitor DP-6,1920x1080,-3840x0,1
  hyprctl keyword monitor DP-7,1920x1080,-1920x0,1
  hyprctl keyword monitor DP-8,1920x1080,-3840x0,1

  hyprctl keyword monitor DP-3,highres,auto,1,mirror,eDP-1
  
  hyprctl keyword workspace 1, monitor:eDP-1, default:true 
  hyprctl keyword workspace [2-5], monitor:eDP-1

  hyprctl keyword workspace 6, monitor:DP-5, default:true
  hyprctl keyword workspace [7-10], monitor:DP-5
        
  hyprctl keyword workspace 6, monitor:DP-7, default:true
  hyprctl keyword workspace [7-10], monitor:DP-7
  
  hyprctl keyword workspace 11, monitor:DP-6, default:true
  hyprctl keyword workspace [12-15], monitor:DP-6
  
  hyprctl keyword workspace 11, monitor:DP-8, default:true
  hyprctl keyword workspace [12-15], monitor:DP-8

elif [ "$1" == "dlr" ]; then
  hyprctl keyword monitor eDP-1,2256x1504,0x0,1
  hyprctl keyword monitor desc:Dell Inc. DELL U2724D 9XBZBP3,2560x1440,2256x0,1
  hyprctl keyword monitor desc:Ancor Communications Inc ASUS VP239 FALMTJ009911,1920x1080,4816x0,1

  hyprctl keyword workspace 1, monitor:eDP-1, default:true 
  hyprctl keyword workspace [2-5], monitor:eDP-1

  hyprctl keyword workspace 6, monitor:DP-5, default:true
  hyprctl keyword workspace [7-10], monitor:DP-5
        
  hyprctl keyword workspace 11, monitor:DP-7, default:true
  hyprctl keyword workspace [12-15], monitor:DP-7
else
  echo "No args"
fi
