#!/usr/bin/env bash

# https://certbot.eff.org/instructions?ws=nginx&os=snap

if ! command -v snap >/dev/null 2>&1; then
  sudo apt-get -y install snapd
fi

sudo snap install snapd
sudo apt-get -y remove certbot
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/local/bin/certbot
