#!/usr/bin/env bash

if command -v flatpak >/dev/null 2>&1; then
  echo "Flatpak already installed"
  exit
fi

sudo apt-get update
sudo apt-get -y install flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo reboot
