#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install keybase Keybase

require curl

goto_tempdir

curl -O https://dist.keybase.io/linux/deb/keybase-latest-amd64.deb
sudo dpkg -i keybase-latest-amd64.deb
