#!/usr/bin/env bash

if ! command -v flatpak >/dev/null 2>&1; then
	echo "Install flatpak first"
  exit
fi

if flatpak info flathub org.gimp.GIMP >/dev/null 2>&1; then
  echo "GIMP already installed"
  exit
fi

flatpak install flathub org.gimp.GIMP
