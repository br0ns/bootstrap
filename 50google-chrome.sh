#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install google-chrome "Google Chrome"

goto_tempdir
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo install -f
