#!/bin/bash
set -e
set -o pipefail
echo "Начинаем деплой."
git pull origin master
echo "Создание контенеров"
docker compose -f docker-compose-prod.yaml down
docker compose -f docker-compose-prod.yaml up -d --build
echo "Перезапускаем сервисы"
systemctl reload nginx.service
COMMIT_HASH=$(git rev-parse HEAD)
USER=$(whoami)
source /root/opt/star-burger/backend/star_burger/.env
curl -H "Content-Type: application/json" -X POST https://api.rollbar.com/api/1/deploy/ \
     -d "{\"access_token\":\"$ROLLBAR_TOKEN\",\"environment\":\"production\",\"revision\":\"$COMMIT_HASH\",\"local_username\":\"$USER\"}"
echo "Деплой успешно завершён!"