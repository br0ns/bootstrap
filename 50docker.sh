#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install docker Docker

require curl

goto_tempdir

curl -fsSL https://get.docker.com | sudo sh

sudo groupadd docker || true
sudo usermod -aG docker $USER

sudo service docker start
