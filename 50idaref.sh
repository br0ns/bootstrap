#!/bin/bash
source "$(dirname "$0")/bs.sh"

IDAPATH=$(ls -d /opt/ida* 2> /dev/null | head -n 1)

if [ -z $IDAPATH ] ; then
    WARN "IDA Pro is not installed"
    exit
fi

prompt_install $IDAPATH/plugins/idaref.py IdaRef

goto_tempdir

git clone https://github.com/nologic/idaref.git .
sudo cp -rv archs idaref.py $IDAPATH/plugins/
