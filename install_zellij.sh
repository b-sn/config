#!/usr/bin/env bash

# Source: https://zellij.dev/documentation/installation.html#third-party-repositories

if ! command -v cargo >/dev/null 2>&1; then
	echo "Install Rust first"
  exit
fi

cargo install --locked zellij
