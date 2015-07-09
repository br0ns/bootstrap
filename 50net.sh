#!/bin/bash
source "$(dirname "$0")/bootstrap"

prompt_install net

run mkdir -p ~/bin
for f in net _net_bash_completion ; do
    run wget https://raw.githubusercontent.com/br0ns/net/master/$f -O ~/bin/$f
done
