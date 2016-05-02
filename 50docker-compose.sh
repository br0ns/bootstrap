#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install docker-compose "Docker Compose"

sudo pip install docker-compose
