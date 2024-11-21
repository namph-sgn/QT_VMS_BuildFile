#!/bin/bash

if [ -x "$(command -v docker)" ]; then
    echo "Docker installed"
    docker --version
else
    echo "Install docker"
    sudo -A apt install curl
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo -A sh get-docker.sh
fi

# Setup account for offline docker use