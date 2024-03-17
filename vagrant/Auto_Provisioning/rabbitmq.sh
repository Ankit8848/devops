#!/bin/bash

# Install required packages
sudo yum install epel-release wget -y
sudo yum update -y

# Install RabbitMQ
cd /tmp/
sudo dnf -y install centos-release-rabbitmq-38
sudo dnf --enablerepo=centos-rabbitmq-38 -y install rabbitmq-server

# Start and enable RabbitMQ service
sudo systemctl enable --now rabbitmq-server

# Configure firewall to allow RabbitMQ port
sudo firewall-cmd --add-port=5672/tcp --permanent
sudo firewall-cmd --reload

# Check RabbitMQ service status
sudo systemctl status rabbitmq-server

# Configure RabbitMQ settings
sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator

# Restart RabbitMQ service
sudo systemctl restart rabbitmq-server
