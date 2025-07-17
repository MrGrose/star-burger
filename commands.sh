#!/usr/bin/env bash

set -e
set -o pipefail

echo "Запускаю миграции"
python manage.py migrate --noinput

echo "Загружаю данные"
python manage.py loaddata db_data.json

echo "Запускаю сервер"
exec python manage.py runserver 0.0.0.0:8000