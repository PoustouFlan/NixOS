#!/bin/sh
pushd /home/poustouflan/Configuration
sudo nixos-rebuild switch -I nixos-config=./system/configuration.nix
popd
