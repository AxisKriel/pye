#!/bin/bash
# This script installs pye/tracking scripts into the gateway's crontab
set -e # exit on error

echo "🚀 ~ Installing 'pye/tracking' scripts into the gateway's crontab..."

# Ensure directories exist
sudo mkdir -p /etc/cron.d
sudo mkdir -p /pye

# Copy scripts to their location
sudo cp -r ./tracking /pye/tracking

# Ensure scripts are executable
sudo chmod +x /pye/tracking/*.sh

# Install the cron jobs
echo "@reboot root /pye/tracking/cpu.sh" | sudo tee /etc/cron.d/pye_tracking_cpu > /dev/null
echo "@reboot root /pye/tracking/mem.sh" | sudo tee /etc/cron.d/pye_tracking_mem > /dev/null
echo "@reboot root /pye/tracking/energy.sh" | sudo tee /etc/cron.d/pye_tracking_energy > /dev/null
echo "@reboot root /pye/tracking/power.sh" | sudo tee /etc/cron.d/pye_tracking_power > /dev/null

# Reload crontab to apply changes
sudo systemctl restart cron

# Start the tracking scripts immediately
sudo nohup bash -c "/pye/tracking/cpu.sh" >/dev/null 2>&1 &
sudo nohup bash -c "/pye/tracking/mem.sh" >/dev/null 2>&1 &
sudo nohup bash -c "/pye/tracking/energy.sh" >/dev/null 2>&1 &
sudo nohup bash -c "/pye/tracking/power.sh" >/dev/null 2>&1 &

echo "✅ ~ Installed tracking jobs for: 'cpu', 'mem', 'energy', 'power'"
echo "📂 ~ Tracking scripts are located in '/pye/tracking' & logs are in '/var/log/pye/tracking'"
echo "🔄 ~ Cron jobs have been updated and are now active"
