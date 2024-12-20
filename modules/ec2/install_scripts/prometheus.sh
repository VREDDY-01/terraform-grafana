#!/bin/bash

# Download and extract Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v3.0.1/prometheus-3.0.1.linux-amd64.tar.gz
tar -xvzf prometheus-3.0.1.linux-amd64.tar.gz
sudo mv prometheus-3.0.1.linux-amd64/prometheus /usr/local/bin/
sudo mv prometheus-3.0.1.linux-amd64/promtool /usr/local/bin/

# Configure Prometheus
sudo mkdir /etc/prometheus
sudo mv prometheus-3.0.1.linux-amd64/prometheus.yml /etc/prometheus/

cat <<EOF | sudo tee /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "node_exporter"
    static_configs:
      - targets: ["localhost:9100"]
EOF

# Set up Prometheus as a systemd service
cat <<EOF | sudo tee /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Monitoring
After=network.target

[Service]
User=ec2-user
ExecStart=/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/var/lib/prometheus

[Install]
WantedBy=multi-user.target
EOF

# Create Prometheus data directory
sudo mkdir -p /var/lib/prometheus
sudo chown ec2-user:ec2-user /var/lib/prometheus

# Start Prometheus
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus
