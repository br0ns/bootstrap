#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install net

mkdir -p ~/bin
wget https://raw.githubusercontent.com/br0ns/net/master/net -O ~/bin/net
sudo wget https://raw.githubusercontent.com/br0ns/net/master/_net_bash_completion \
     -O /etc/bash_completion.d/net
