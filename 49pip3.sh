#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install pip3
require python3-pip
sudo pip3 install pip
