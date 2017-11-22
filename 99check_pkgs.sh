#!/bin/bash
source "$(dirname "$0")/bs.sh"

if [ ! -e /etc/apt/apt.conf.d/99check-pkgs ] ; then
    sudo tee /etc/apt/apt.conf.d/99check-pkgs <<EOF
DPkg::Post-Invoke {"$HOME/bin/check-pkgs --recommends";};
EOF
fi

prompt_step "Run \`check-pkgs' now?" "y"

# INFO Updating Linux kernel headers in case kernel modules are installed
# apt-get -y install linux-headers-$(uname -r)

check-pkgs --recommends
