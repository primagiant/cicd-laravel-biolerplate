#!/bin/bash

set -e

APP_PATH="/home/devops/app"

# Renew SSL certificate
sudo certbot renew --quiet

# Restart Nginx (via Docker Compose)
cd $APP_PATH
docker-compose restart nginx

echo "SSL certificate diperbarui (jika ada)"
