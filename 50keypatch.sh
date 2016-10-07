#!/bin/bash
source "$(dirname "$0")/bs.sh"

IDAPATH=$(ls -d /opt/ida* 2> /dev/null | head -n 1)

if [ -z $IDAPATH ] ; then
    WARN "IDA Pro is not installed"
    exit
fi

prompt_install $IDAPATH/plugins/keypatch.py IdaRef

cd $IDAPATH/plugins/
sudo wget https://raw.githubusercontent.com/keystone-engine/keypatch/master/keypatch.py
