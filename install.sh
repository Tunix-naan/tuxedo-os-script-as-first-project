#! /bin/bash
set -e

curl -fsSL https://ollama.com/install.sh | sh

sudo systemctl enable --now ollama

ollama --version

ollama pull llama3.1:8b

echo "type /bye to exit, ollama run llama3.1 to start it"
