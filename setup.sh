#!/bin/bash

# ===============================
# Script setup user devops & Docker
# ===============================

set -e

# 1. Buat user devops jika belum ada
if id "devops" &>/dev/null; then
    echo "User devops sudah ada, skip pembuatan user"
else
    echo "Membuat user devops..."
    sudo adduser --disabled-password --gecos "" devops
    sudo usermod -aG sudo devops
fi

# 2. Login sebagai devops
echo "Pastikan selanjutnya login sebagai devops: su - devops"

# 3. Update & install dependencies
sudo apt update && sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    git \
    openssh-client

# 4. Install Docker
echo "Menginstall Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 5. Tambahkan devops ke group docker
sudo usermod -aG docker devops
echo "User devops ditambahkan ke group docker"

# 6. Install Docker Compose v2
DOCKER_COMPOSE_VERSION=2.24.1
sudo curl -L "https://github.com/docker/compose/releases/download/v$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
echo "Docker Compose $DOCKER_COMPOSE_VERSION terinstall"

# 7. Jalakan Docker Compose

# 8. Generate SSH key untuk devops
SSH_DIR="/home/devops/.ssh"
KEY_PATH="$SSH_DIR/id_rsa"

if [ ! -f "$KEY_PATH" ]; then
    echo "Membuat SSH key untuk devops..."
    sudo -u devops mkdir -p $SSH_DIR
    sudo -u devops ssh-keygen -t rsa -b 4096 -f $KEY_PATH -N ""
    sudo -u devops chmod 700 $SSH_DIR
    sudo -u devops chmod 600 $KEY_PATH
    cat $KEY_PATH.pub >> $SSH_DIR/authorized_keys
    echo "SSH key telah dibuat di $KEY_PATH"
else
    echo "SSH key sudah ada, skip pembuatan"
fi

# 8. Jalankan Docker Compose (opsional)
echo "Menjalankan Docker Compose jika docker-compose.yml tersedia di home devops"
if [ -f "/home/devops/docker-compose.yml" ]; then
    cd /home/devops
    sudo -u devops docker-compose up -d --build
    echo "Docker Compose dijalankan"
else
    echo "docker-compose.yml tidak ditemukan, skip menjalankan Docker Compose"
fi

# 9. Install Certbot untuk SSL
echo "Menginstall Certbot & Nginx plugin..."
sudo apt update
sudo apt install -y certbot python3-certbot-nginx
echo "Certbot terinstall"


echo "=== Setup selesai ==="
echo "Login sebagai devops: su - devops"
echo "Public key: $(cat $KEY_PATH)"
