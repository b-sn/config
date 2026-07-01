#!/usr/bin/env bash

if command -v logseq >/dev/null 2>&1; then
	echo "LogSeq already installed"
  exit
fi

curl -fsSL https://raw.githubusercontent.com/logseq/logseq/master/scripts/install-linux.sh | sudo bash
