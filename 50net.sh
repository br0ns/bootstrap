#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install net

mkdir -p ~/bin

if [ ! -e ~/bin/net ] ; then
    wget https://raw.githubusercontent.com/br0ns/net/master/net -O ~/bin/net
    chmod +x ~/bin/net
fi

if [ ! -e /etc/bash_completion.d/net ] ; then
    sudo wget https://raw.githubusercontent.com/br0ns/net/master/_net_bash_completion \
         -O /etc/bash_completion.d/net
fi
