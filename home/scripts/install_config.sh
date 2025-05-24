#!/usr/bin/env bash

echo "Installing $1"

sudo -E gnome-disks

lsblk -o name,FSTYPE,label,size,uuid

while true; do
    read -p "Do you wish to continue? " yn
    case $yn in
        [Yy]* ) make install; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "--- mounting ---"
sudo mount /dev/disk/by-label/NIXROOT /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/NIXBOOT /mnt/boot

echo "--- swapfile ---"
sudo dd if=/dev/zero of=/mnt/.swapfile bs=1024 count=2097152 # 2GB size
sudo chmod 600 /mnt/.swapfile
sudo mkswap /mnt/.swapfile
sudo swapon /mnt/.swapfile

echo "--- nixos-generate-config ---"
sudo nixos-generate-config --root /mnt

echo "--- nixos install ---"
cd ~/.
git clone https://github.com/MaartenBehn/nixos
cd nixos

sudo rm ~/nixos/hardware-configuration.nix
sudo cp /mnt/etc/nixos/hardware-configuration.nix ~/nixos/hardware-configuration.nix

sudo chmod o+rx /mnt
sudo nixos-install --flake .#$1 --impure
