#!/bin/bash

# Install Memcached
sudo dnf install epel-release -y
sudo dnf install memcached -y

# Start and enable Memcached service
sudo systemctl start memcached
sudo systemctl enable memcached

# Check Memcached service status
sudo systemctl status memcached

# Update Memcached configuration to listen on all interfaces
sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached

# Restart Memcached service for changes to take effect
sudo systemctl restart memcached

# Open firewall ports for Memcached
sudo firewall-cmd --add-port=11211/tcp --permanent
sudo firewall-cmd --add-port=11111/udp --permanent
sudo firewall-cmd --reload

# Start Memcached with specific parameters
sudo memcached -p 11211 -U 11111 -u memcached -d
