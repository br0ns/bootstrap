#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install pip

require python-pip
sudo pip install pip
