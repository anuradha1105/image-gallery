#!/usr/bin/env bash
set -euxo pipefail

sudo apt-get update
sudo apt-get install -y python3 python3-pip python3-venv

cd /home/vagrant/app
python3 -m venv .venv
source .venv/bin/activate
pip install --no-cache-dir -r requirements.txt

sudo tee /etc/systemd/system/flaskapp.service > /dev/null <<'EOF'
[Unit]
Description=Flask app (Gunicorn)
After=network.target

[Service]
User=vagrant
WorkingDirectory=/home/vagrant/app
Environment="PATH=/home/vagrant/app/.venv/bin"
ExecStart=/home/vagrant/app/.venv/bin/gunicorn -b 0.0.0.0:5000 app:app
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable flaskapp
sudo systemctl restart flaskapp
