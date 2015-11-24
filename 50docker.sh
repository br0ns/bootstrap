#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install docker Docker

require apt-transport-https

goto_tempdir

sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 \
     --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

if ! grep dockerproject /etc/apt/sources.list ; then
    sudo tee -a /etc/apt/sources.list <<EOF

deb https://apt.dockerproject.org/repo debian-jessie main
EOF
    sudo apt-get update
fi

sudo apt-get install docker-engine
sudo service docker start