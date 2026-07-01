#!/usr/bin/env bash

# Source: https://zellij.dev/documentation/installation.html#third-party-repositories

if command -v zellij >/dev/null 2>&1; then
  echo "Zellij already installed"
  exit
fi

if ! command -v cargo >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  . "$HOME/.cargo/env"
fi

cargo install --locked zellij
