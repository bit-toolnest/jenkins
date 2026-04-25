#!/bin/bash
set -e

echo "=== Jenkins Installer Script ==="

# Adjust if newer LTS is required
JENKINS_VERSION="2.555.1"

# 1) Update system
echo "➡ Updating system packages..."
sudo apt update -y

# 2) Install Java 21 (required for Jenkins 2.555.1+)
if ! java -version 2>&1 | grep -q "21"; then
  echo "➡ Installing OpenJDK 21..."
  sudo apt install -y openjdk-21-jre
else
  echo "✅ Java 21 already installed"
fi

# 3) Download Jenkins LTS .deb package only if not installed or version mismatch
INSTALLED_VERSION=$(dpkg -l | grep jenkins | awk '{print $3}' | cut -d'-' -f1 || true)

if [ "$INSTALLED_VERSION" != "$JENKINS_VERSION" ]; then
  echo "➡ Updating Jenkins from ${INSTALLED_VERSION:-none} to $JENKINS_VERSION..."
  wget -q https://pkg.jenkins.io/debian-stable/binary/jenkins_${JENKINS_VERSION}_all.deb -O jenkins.deb
  sudo apt install ./jenkins.deb -y --allow-downgrades

  # Reload systemd and start Jenkins
  sudo systemctl daemon-reload
  sudo systemctl enable jenkins
  sudo systemctl restart jenkins

  echo "✅ Jenkins $JENKINS_VERSION installed and running"
else
  echo "✅ Jenkins already at version $JENKINS_VERSION"
fi

echo "🎯 Jenkins install script finished successfully!"
