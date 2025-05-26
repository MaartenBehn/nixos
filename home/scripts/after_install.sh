#!/usr/bin/env bash

sudo swapon /.swapfile

ssk-keygen
cat ~/.ssh/id_ed25519.pub

while true; do
    read -p "Have you added the key to github.com?" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

cd ~/.
git clone git@github.com:MaartenBehn/nixos.git

nix-rebuild

