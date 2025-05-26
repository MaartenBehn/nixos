#!/usr/bin/env bash

sudo -E gnome-disks

lsblk -o name,FSTYPE,label,size,uuid
