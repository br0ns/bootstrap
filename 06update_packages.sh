#!/bin/bash
source "$(dirname "$0")/bootstrap"

prompt_step "Update packages now?" "y"

run sudo apt-get update
run sudo apt-get upgrade
run sudo apt-get autoremove --purge
run sudo apt-get autoclean
