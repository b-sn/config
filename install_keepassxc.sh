#!/usr/bin/env bash

if ! command -v flatpak >/dev/null 2>&1; then
	echo "Install flatpak first"
  exit
fi

if flatpak info org.keepassxc.KeePassXC >/dev/null 2>&1; then
  echo "KeepAssXC already installed"
  exit
fi

flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install --user flathub org.keepassxc.KeePassXC
