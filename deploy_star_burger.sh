#!/bin/bash
set -e
set -o pipefail
echo "Начинаем деплой."
cd /root/opt/star-burger
source env/bin/activate
git pull origin master
echo "Создаем папки для media и frontend и выставляем права"
sudo mkdir -p /var/www/media /var/www/frontend
sudo chmod -R 777 /var/www/media /var/www/frontend
echo "Создание контенеров"
docker compose -f docker-compose-prod.yaml up -d --build
echo "Перезапускаем сервисы"
systemctl reload nginx.service
COMMIT_HASH=$(git rev-parse HEAD)
USER=$(whoami)
source /root/opt/star-burger/star_burger/.env
curl -H "Content-Type: application/json" -X POST https://api.rollbar.com/api/1/deploy/ \
     -d "{\"access_token\":\"$ROLLBAR_TOKEN\",\"environment\":\"production\",\"revision\":\"$COMMIT_HASH\",\"local_username\":\"$USER\"}"
echo "Деплой успешно завершён!"