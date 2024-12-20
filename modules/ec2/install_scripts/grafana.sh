#!/bin/bash

# Add Grafana repository
cat <<EOF | sudo tee /etc/yum.repos.d/grafana.repo
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
EOF

# Update the Packages
sudo yum update -y

# Install Grafana
sudo yum install -y grafana

# Start Grafana
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
