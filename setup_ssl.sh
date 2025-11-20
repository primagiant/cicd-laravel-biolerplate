#!/bin/bash

set -e

DOMAIN="example.com"
EMAIL="kadekprimagiantmartadinata@gmail.com"  # email untuk notifikasi Certbot
APP_PATH="/home/devops/app"

# Pastikan Nginx running
if ! pgrep nginx >/dev/null; then
    echo "Nginx tidak running, jalankan Docker Compose dulu"
    exit 1
fi

# Generate SSL certificate dengan Certbot
sudo certbot --nginx -d $DOMAIN --non-interactive --agree-tos --email $EMAIL

# Restart Nginx (via Docker Compose)
cd $APP_PATH
docker-compose restart nginx

echo "SSL certificate untuk $DOMAIN sudah terpasang"
