#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_step "Update packages now?" "y"

apt-get update
apt-get upgrade
apt-get autoremove --purge
apt-get autoclean
