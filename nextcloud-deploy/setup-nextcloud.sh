#!/bin/bash

# ────────────────────────────────────────────────────────────────────────────────
# 🛠️ Nextcloud Setup Script for Oracle Cloud ARM (RHEL9) with HTTPS via DuckDNS
# Author: you
# Safe for GitHub (personal details masked)
# ────────────────────────────────────────────────────────────────────────────────

set -e

# ─── Variables (Edit These) ─────────────────────────────────────────────────────
NEXTCLOUD_DOMAIN="your-subdomain.duckdns.org"
MYSQL_ROOT_PASSWORD="StrongRootPass123"  # Use secrets in production
MYSQL_DATABASE="nextcloud"
MYSQL_USER="nextclouduser"
MYSQL_PASSWORD="StrongDbPass123"         # Use secrets in production

# ─── Update & Install Packages ───────────────────────────────────────────────────
echo "📦 Installing system packages..."
sudo dnf install -y podman python3-pip git curl nginx firewalld policycoreutils-python-utils

# ─── Install podman-compose ──────────────────────────────────────────────────────
echo "🐳 Installing podman-compose..."
pip3 install --user podman-compose
export PATH=$PATH:$HOME/.local/bin

# ─── Open Firewall Ports ─────────────────────────────────────────────────────────
echo "🔓 Configuring firewall..."
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --add-service=https --permanent
sudo firewall-cmd --add-port=8080/tcp --permanent
sudo firewall-cmd --reload

# ─── Create Application Directory ────────────────────────────────────────────────
mkdir -p ~/nextcloud && cd ~/nextcloud

# ─── Write podman-compose.yml ────────────────────────────────────────────────────
echo "📝 Writing podman-compose.yml..."
cat <<EOF > podman-compose.yml
version: '3'
services:
  db:
    image: mariadb:10.6
    container_name: nextcloud_db
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - ./db:/var/lib/mysql:Z
    restart: always

  redis:
    image: redis:alpine
    container_name: nextcloud_redis
    restart: always

  app:
    image: nextcloud
    container_name: nextcloud_app
    ports:
      - "8080:80"
    depends_on:
      - db
      - redis
    environment:
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_HOST: db
      REDIS_HOST: redis
    volumes:
      - ./nextcloud:/var/www/html:Z
    restart: always
EOF

# ─── Launch Containers ───────────────────────────────────────────────────────────
echo "🚀 Starting Nextcloud stack with podman-compose..."
podman-compose up -d

# ─── SELinux Permission Fix ──────────────────────────────────────────────────────
echo "🔧 Adjusting SELinux settings..."
sudo setsebool -P httpd_can_network_connect 1

# ─── Setup Reverse Proxy & HTTPS (Instructions Only) ─────────────────────────────
echo "🔒 For HTTPS, run the following after DuckDNS is configured:"
echo ""
echo "  sudo dnf install -y python3-pip"
echo "  pip3 install certbot"
echo "  sudo systemctl stop nginx"
echo "  sudo certbot certonly --standalone -d $NEXTCLOUD_DOMAIN"
echo "  # Configure nginx with proxy to localhost:8080 using the certs"
echo ""
echo "🔄 Don't forget to add your domain to 'trusted_domains' in config.php"
echo "📂 config location: ~/nextcloud/nextcloud/config/config.php"
echo "✅ Example:"
echo "  'trusted_domains' => [ 'localhost', '$NEXTCLOUD_DOMAIN' ]"
echo ""
echo "🎉 Done! Access Nextcloud at: http://<your-server-ip>:8080 or https://$NEXTCLOUD_DOMAIN after certs"

