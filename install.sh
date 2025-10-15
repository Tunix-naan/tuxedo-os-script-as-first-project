#! /bin/bash
set -e

curl -fsSL https://ollama.com/install.sh | sh

wait 1

sudo systemctl enable --now ollama

ollama --version
