---
layout: slide
title: Docker-compose
---

![docker-components](/assets/images/docker/docker-compose.png)

Docker Compose - это инструмент для определения и запуска многоконтейнерных приложений Docker.

--

Возможности Compose:

- Запуск нескольких изолированных сред на одном хосте

- Настройка volumes при создании контейнеров

- Удобный менеджмент запущенных контейнеров

- Удобная конфигурация контейнеров и коммуникации между ними


---

## docker-compose.yml

С Compose вы используете файл YAML для настройки сервисов(контейнеров) вашего приложения и одну команду для создания и запуска всех сервисов из этого файла конфигурации

--

![docker-compose-example](/assets/images/docker/docker-compose-example.png)

--

```yaml
# Version - версия синтаксиса compose-файла
version: '3.1'

# Volume – это папка на вашей локальной машине примонтированная внутрь контейнера
volumes: # Объявим volumes, которые будут доступны в сервисах
  postgres:

# Service - запущенный контейнер
services: # Объявляем сервисы которые будут запущены с помощью compose
  db:
    # ...

  in_memory_store:
    # ...

  server_app:
    # ...

  server_worker_app:
    # ...
```

--

```yaml
# ...
  db: # Объявляем сервис базы данных
    image: postgres:9.6 # Используем официальный образ Postgresql из Docker Hub
    expose:
      - 5432 # Выделяем для postgres 5432-ый порт контейнера
    environment: # Указываем ENV-переменных в контейнере
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: spreedemo_development
    volumes:
      - postgres:/var/lib/postgresql/data # Директория контейнера `data` будет записываться в volume `postgres`
    healthcheck:
      test: ["CMD", "pg_isready", "-U", "postgres"] # Команда для проверки состояния сервиса
# ...
```

--

```yaml
# ...
  server_app: # Объявляем сервис основного приложения на Ruby on Rails
    build: . # Используем Dockerfile из текущей директории как образ
    command: bundle exec rails server --binding 0.0.0.0 # Переопределяем команду запуска контейнера
    entrypoint: "./docker-entrypoint.sh" # Команда перед запуском контейнера
    volumes:
      - ./app:/home/www/spreedemo/app # Директория контейнера `app` будет ссылаться на директорию `app` в Host OS (локальная нода)
      - ./vendor/assets:/home/www/spreedemo/vendor/assets
    environment:
      RAILS_ENV: development
      DB_HOST: db # Указываем имя сервиса как хост базы данных
      DB_PORT: 5432
      DB_NAME: spreedemo_development
      DB_USERNAME: postgres
      DB_PASSWORD: postgres
    depends_on:
      - db # Указываем что основное приложение должно запустится после db сервиса
      - in_memory_store
    expose:
      - 3000 # Выделяем для puma 3000-ый порт контейнера
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000"]
# ...
```

--

## Запуск

```bash
# `-p` указывает, какой префикс добавить контейнерам. Желательно использовать подобный контекст, чтобы когда проектов на Docker станет больше, вам было проще ориентироваться по контексту;
# `-f` указывает, какой docker-compose файл использовать.

docker-compose -f docker-compose.yml -p spreeproject up
```

Другие [полезные команды](https://docs.docker.com/compose/reference) для работы с compose.

---

## Задание

Развернуть локально [Spree приложение](https://github.com/bezrukavyi/spree-docker-demo) со всеми зависимыми сервисами с помощью Docker и Docker-compose
