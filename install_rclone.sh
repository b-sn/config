#!/usr/bin/env bash

if command -v rclone >/dev/null 2>&1; then
  echo "Rclone already installed; updating"
  rclone selfupdate
else
  sudo -v ; curl https://rclone.org/install.sh | sudo bash
fi
