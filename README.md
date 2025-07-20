# Сайт доставки еды Star Burger

Это сайт сети ресторанов Star Burger. Здесь можно заказать превосходные бургеры с доставкой на дом.

![скриншот сайта](https://dvmn.org/filer/canonical/1594651635/686/)


Сеть Star Burger объединяет несколько ресторанов, действующих под единой франшизой. У всех ресторанов одинаковое меню и одинаковые цены. Просто выберите блюдо из меню на сайте и укажите место доставки. Мы сами найдём ближайший к вам ресторан, всё приготовим и привезём.

На сайте есть три независимых интерфейса. Первый — это публичная часть, где можно выбрать блюда из меню, и быстро оформить заказ без регистрации и SMS.

Второй интерфейс предназначен для менеджера. Здесь происходит обработка заказов. Менеджер видит поступившие новые заказы и первым делом созванивается с клиентом, чтобы подтвердить заказ. После оператор выбирает ближайший ресторан и передаёт туда заказ на исполнение. Там всё приготовят и сами доставят еду клиенту.

Третий интерфейс — это админка. Преимущественно им пользуются программисты при разработке сайта. Также сюда заходит менеджер, чтобы обновить меню ресторанов Star Burger.

## Содержание

- [Структура проекта](#структура-проекта)
- [Настройки](#настройки)
- [Установка](#установка)
- [Запуск Dev-версии](#запуск-dev-версии)
- [Запуск Prod-версии](#запуск-prod-версии)
- [Автоматизация деплоя](#автоматизация-деплоя)
- [Цели проекта](#цели-проекта)

## Структура проекта

- `docker-compose-prod.yaml` — конфигурация для продакшен окружения
- `docker-compose-dev.yaml` — конфигурация для разработки (локально)

## Настройки: 
1. Клонируйте репозиторий:

    ```python
    https://github.com/MrGrose/star-burger.git
    ```

2. Cоздайте файл `.env` в каталоге `star_burger/` со следующими настройками:

    - `DEBUG` — дебаг-режим. Поставьте `False`.
    - `SECRET_KEY` — секретный ключ проекта. Он отвечает за шифрование на сайте. Например, им зашифрованы все пароли на вашем сайте.
    - `ALLOWED_HOSTS` — [см. документацию Django](https://docs.djangoproject.com/en/3.1/ref/settings/#allowed-hosts)
    - `YANDEX-API-KEY` - [см. инструкцию Yandex geocoder API](https://dvmn.org/encyclopedia/api-docs/yandex-geocoder-api/)
    - `ROLLBAR_TOKEN` - [Ваш токен Rollbar](https://app.rollbar.com/a/grachev.ro/p/star-burger/settings/access_tokens)
    - `DATABASE_URL` - [DATABASE_URL](https://github.com/jazzband/dj-database-url)

3. Установка 

    Убедитесь, что у вас установлены:
    - [Docker](https://docs.docker.com/get-docker/)
    - [Docker Compose](https://docs.docker.com/compose/install/)


## Запуск Dev-версии
Для запуска всех сервисов проекта используется [Docker Compose](https://docs.docker.com/compose/install/). В одной команде вы сможете запустить backend, frontend и базу данных.
В корне проекта расположен файл `docker-compose-dev.yaml`.


1. Клонируйте репозиторий и перейдите в папку:
```bash
git clone https://github.com/MrGrose/star-burger.git
cd star-burger
```
2. Создайте и отредактируйте `.env` (см. [Настройки](#Настройки)).

3. Запустите сервисы Docker Compose:
```bash
docker compose -f docker-compose-dev.yaml up
```
Эта команда:
- Запустит контейнер с базой данных (PostgreSQL).
- Запустит backend-контейнер (приложение на Django), который подключается к базе.
- Запустит frontend-контейнер.

4. Откройте в браузере:

[http://localhost:8000](http://localhost:8000)

5. Остановка всех контейнеров:
```bash
docker compose -f docker-compose-dev.yaml down
```
6. Просмотр логов backend:
```bash
docker compose -f docker-compose-dev.yaml logs -f backend
```
7. Пересборка образов (например, после изменений в коде):
```bash
docker compose -f docker-compose-dev.yaml build
docker compose -f docker-compose-dev.yaml up -d
```


## Запуск Prod-версии
Не включил в readme готовую конфигурацию NGINX и Certbot, так как эти настройки сильно зависят от инфраструктуры и доменных имён. Но рекомендуем руководствоваться проверенными гайдами:

- Статья с подробной примерной конфигурацией NGINX и Certbot для Docker на Habr:
    https://habr.com/ru/articles/918462/
- Пример репозитория с автоматической установкой и настройкой NGINX + Certbot + Docker:
    https://gitflic.ru/project/neatek/nginx-docker-certbot




1. Клонируйте репозиторий и перейдите в папку:
```bash
git clone https://github.com/MrGrose/star-burger.git
cd star-burger
```

2. Сборка и запуск.

    Из корня проекта:

    ```bash
    docker compose -f docker-compose-prod.yaml up --build -d
    ```
3. Остановка контейнеров
    ```bash
    docker compose -f docker-compose-prod.yaml down
    ```
4. Проверка логов backend
    ```bash
    docker compose -f docker-compose-prod.yaml logs -f backend
    ```

## Автоматизация деплоя:

Запустите скрипт из корня проекта:

    ```bash
    ./deploy_star_burger.sh
    ```

Что делает скрипт:
- Обновляет исходный код
- Собирает и запускает контейнеры через Docker Compose на продакшен-конфигурации
- Перегружает сервис nginx, чтобы применять новые настройки и файлы
- Отправляет уведомление в Rollbar о новом деплое
- Выводит сообщение об успешном завершении деплоя
- Прекращает выполнение при любой ошибке (без продолжения)



## Цели проекта

Код написан в учебных целях — это урок в курсе по Python и веб-разработке на сайте [Devman](https://dvmn.org). За основу был взят код проекта [FoodCart](https://github.com/Saibharath79/FoodCart).

