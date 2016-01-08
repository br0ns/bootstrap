#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install net

require iproute2 ethtool net-tools iw wireless-tools udhcpc wpasupplicant \
        wpasupplicant mawk e2fsprogs coreutils procps python-yaml

mkdir -p ~/bin

if [ ! -e ~/bin/net ] ; then
    wget https://raw.githubusercontent.com/br0ns/net/master/net -O ~/bin/net
    chmod +x ~/bin/net
fi

if [ ! -e /etc/bash_completion.d/net ] ; then
    sudo wget https://raw.githubusercontent.com/br0ns/net/master/_net_bash_completion \
         -O /etc/bash_completion.d/net
fi
