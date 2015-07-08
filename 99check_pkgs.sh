#!/bin/bash
source "$(dirname "$0")/bootstrap"

if [ ! -e /etc/apt/apt.conf.d/99check-pkgs ] ; then
    run sudo tee /etc/apt/apt.conf.d/99check-pkgs <<EOF
DPkg::Post-Invoke {"$HOME/bin/check-pkgs";};
EOF
fi

prompt_step "Run \`check-pkgs' now?" "y"

INFO Updating "Linux kernel headers in case kernel modules are installed"
run sudo apt-get -y install linux-headers-$(uname -r)
run check-pkgs
