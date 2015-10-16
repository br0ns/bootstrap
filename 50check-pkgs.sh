#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install check-pkgs

mkdir -p ~/bin
wget https://raw.githubusercontent.com/br0ns/check-pkgs/master/check-pkgs -O ~/bin/check-pkgs
chmod +x ~/bin/check-pkgs
sudo tee /etc/apt/apt.conf.d/99check-pkgs <<EOF
DPkg::Post-Invoke {"$HOME/bin/check-pkgs";};
EOF
