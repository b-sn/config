#!/usr/bin/env bash

if ! command -v flatpak >/dev/null 2>&1; then
	echo "Install flatpak first"
  exit
fi

if flatpak info org.telegram.desktop >/dev/null 2>&1; then
  echo "Telegram already installed"
  exit
fi

flatpak install flathub org.telegram.desktop
