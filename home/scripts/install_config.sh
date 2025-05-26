#!/usr/bin/env bash

echo config: $1
echo root: dev/$2
echo boot: dev/$3

while true; do
    read -p "Do you wish to continue? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "--- mounting ---"
sudo mount /dev/$2 /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/$3 /mnt/boot

echo "--- swapfile ---"
sudo dd if=/dev/zero of=/mnt/.swapfile bs=1024 count=2097152 # 2GB size
sudo chmod 600 /mnt/.swapfile
sudo mkswap /mnt/.swapfile

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
