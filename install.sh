#! /bin/bash
set -e

curl -fsSL https://ollama.com/install.sh | sh

sudo systemctl enable --now ollama

ollama --version

ollama --install llama3.1:8b

echo "type "ollama --run llama3.1" to begin using, type /bye to exit"
