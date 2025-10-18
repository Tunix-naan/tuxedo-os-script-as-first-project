#!/bin/bash
set -e

# === install ollama ===

curl -fsSL https://ollama.com/install.sh | sh

sudo systemctl enable --now ollama

ollama --version

ollama pull llama3.1:8b

# === Install Openwebui ===

# === Install and/or update dependencies ===
sudo apt update
sudo apt install -y python3 python3-venv python3-pip git

# === Create a low priviliged user for openwebui ===
if ! id -u openwebui >/dev/null 2>&1; then
    sudo useradd -m -s /bin/bash openwebui
fi

# === make and setup /opt/openwebui ===
sudo mkdir -p /opt/openwebui
sudo chown -R openwebui:openwebui /opt/openwebui

# === install openwebui with python-pip ===
sudo -u openwebui bash <<'EOF'
cd /opt/openwebui
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install open-webui

# Create default config incase it doesn’t exist
mkdir -p ~/.config/open-webui
cat > ~/.config/open-webui/config.json <<CONFIG
{
  "OLLAMA_BASE_URL": "http://localhost:11434",
  "WEBUI_PORT": 3000,
  "ALLOW_REMOTE_ACCESS": false,
  "DEBUG": false
}
CONFIG
EOF

# === Create systemd service ===
sudo tee /etc/systemd/system/openwebui.service > /dev/null <<'SERVICE'
[Unit]
Description=Open WebUI Service
After=network.target ollama.service

[Service]
User=openwebui
WorkingDirectory=/opt/openwebui
Environment="PATH=/opt/openwebui/venv/bin"
ExecStart=/opt/openwebui/venv/bin/open-webui serve --host 0.0.0.0 --port 3000
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
SERVICE

# === Enable and start service ===
sudo systemctl daemon-reload
sudo systemctl enable --now openwebui

echo "Open WebUI installed and running on http://localhost:3000"
echo "It connects automatically to Ollama at http://localhost:11434"

