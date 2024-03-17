#!/bin/bash

# Update package repositories and install Nginx
apt update
apt install nginx -y

# Create Nginx configuration for reverse proxy
cat <<EOT > /etc/nginx/sites-available/devopsWeb
upstream devopsWeb {
  server app01:8080;
}

server {
  listen 80;
  server_name localhost;

  location / {
    proxy_pass http://devopsWeb;
  }
}
EOT

# Enable the Nginx site configuration
ln -s /etc/nginx/sites-available/devopsWeb /etc/nginx/sites-enabled/devopsWeb

# Remove the default Nginx configuration if exists
rm -f /etc/nginx/sites-enabled/default

# Restart Nginx service
systemctl restart nginx
systemctl enable nginx
