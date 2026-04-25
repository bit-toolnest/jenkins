#!/bin/bash
set -e

echo "=== Jenkins Uninstaller Script ==="

# 1) Stop Jenkins service
echo "➡ Stopping Jenkins service..."
sudo systemctl stop jenkins || true
sudo systemctl disable jenkins || true

# 2) Remove Jenkins package
echo "➡ Removing Jenkins package..."
sudo apt remove --purge jenkins -y || true

# 3) Remove Jenkins directories
echo "➡ Cleaning Jenkins directories..."
sudo rm -rf /var/lib/jenkins || true
sudo rm -rf /etc/jenkins || true
sudo rm -rf /var/log/jenkins || true

# 4) Remove Jenkins user if desired (optional)
if id "jenkins" &>/dev/null; then
  echo "➡ Removing Jenkins user..."
  sudo deluser --remove-home jenkins || true
fi

# 5) Final apt cleanup
echo "➡ Running apt cleanup..."
sudo apt autoremove -y
sudo apt clean

echo "🎯 Jenkins uninstall process finished!"
