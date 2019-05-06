---
layout: slide
title: Docker
---

## Постановка  проблемы

- Неудачи при попытке установить все зависимое ПО, при этом не "сломав" ничего локально
- Непонимание, как запустить приложение
- Недостаток опыта в разворачивании приложения на удаленных серверах
- Поддержка инфраструктуры приложения на удаленных серверах
- Масштабирование приложения на production окружении

--

## Решение
 
![logo.jpeg](/assets/images/docker/logo.jpeg)

Упаковываваем и запускаем ваше ПО со всеми его зависимостями в небольших изолированных средах, называемых контейнерами

--

## Преимущества

- Независимость от архитектуры сервера

- Удобное управление версиями и зависимостями

- Простота масштабирования

- Оптимальное использование ресурсов

- Инфраструктура как код

--

## Недостатки

- Производительность

- Усложнение архитектуры

- Непростая настройка и поддержка

- Плохая обратная совместимость

---

## Как это работает?

![docker-components](/assets/images/docker/docker-components.png)

--

## Virtual Machine vs Docker

--

![docker-vm](/assets/images/docker/vm.png)

Виртуальной машина предоставляет среде больше ресурсов, чем требуется большинству приложений

--

![docker-container](/assets/images/docker/container.png)

Контейнер работает в Linux и разделяет ядро HostOS с другими контейнерами. Он запускается в отдельном процессе, занимая минимум памяти

---

## Images and Layers

![image-layer](/assets/images/docker/image-layer.png)

Docker образ состоит из **ряда слоев**

Каждый слой представляет собой **ряд изменений** от предыдущего слоя

--

## Containers and Layers

![conainers-layer](/assets/images/docker/conainers-layer.png)

Когда запускается контейнер, он создает еще один слой поверх образа

Только слой контейнера доступен для **записи**

--

## Containers and Volumes

![volumes.png](/assets/images/docker/volumes.png)

Docker volume – папка на HostOS, "примонтированная" к файловой системе контейнера

---

## Dockerfile

![dockerfile.png](/assets/images/docker/dockerfile.png)

Это инструкцией для сборки образ вашего ПО

--

Dockerfile состоит из команд (RUN, ENTRYPOINT, CMD и другие). Каждая команда создание нового слоя при сборке образа. Структура связей между слоями в Docker - иерархическая.

![image-layer](/assets/images/docker/image-layer.png)

--

Базовый образ и установка ПО

```bash
# Dockerfile

# Layer 0. Качаем образ Debian OS с установленным ruby версии 2.5 и менеджером для управления gem'ами bundle из DockerHub. Используем его в качестве родительского образа.
FROM ruby:2.5.1-slim

# Layer 1. Задаем пользователя, от чьего имени будут выполняться последующие команды RUN, ENTRYPOINT, CMD и т.д.
USER root

# Layer 2. Обновляем и устанавливаем нужное для Web сервера ПО
RUN apt-get update -qq && apt-get install -y \
  build-essential libpq-dev libxml2-dev libxslt1-dev nodejs imagemagick apt-transport-https curl nano

# Layer 3. Создаем переменные окружения которые буду дальше использовать в Dockerfile
ENV APP_USER app
ENV APP_USER_HOME /home/$APP_USER
ENV APP_HOME /home/www/spreedemo
```

--

Пользователь для будущего контейнера

```bash
# Dockerfile

# Layer 4. Поскольку по умолчанию Docker запускаем контейнер от имени root пользователя, то настоятельно рекомендуется создать отдельного пользователя c определенными UID и GID и запустить процесс от имени этого пользователя.
RUN useradd -m -d $APP_USER_HOME $APP_USER

# Layer 5. Даем root пользователем пользователю app права owner'а на необходимые директории
RUN mkdir /var/www && \
   chown -R $APP_USER:$APP_USER /var/www && \
   chown -R $APP_USER $APP_USER_HOME

# Layer 6. Создаем и указываем директорию в которую будет помещено приложение. Так же теперь команды RUN, ENTRYPOINT, CMD будут запускаться с этой директории.
WORKDIR $APP_HOME

# Layer 7. Указываем все команды, которые будут выполняться от имени app пользователя
USER $APP_USER
```

--

Кладем в образ код и устанавливаем gems и assets

```bash
# Dockerfile

# Layer 8. Добавляем файлы Gemfile и Gemfile.lock из директории, где лежит Dockerfile (root директория приложения на HostOS) в root директорию WORKDIR
COPY Gemfile Gemfile.lock ./

# Layer 9. Вызываем команду по установке gem-зависимостей. Рекомендуется запускать эту команду от имени пользователя от которого будет запускаться само приложение
RUN bundle check || bundle install

# Layer 10. Копируем все содержимое директории приложения в root-директорию WORKDIR
COPY . .

# Layer 11. Указываем все команды, которые будут выполняться от имени root пользователя
USER root

# Layer 12. Даем root пользователем пользователю app права owner'а на WORKDIR
RUN chown -R $APP_USER:$APP_USER "$APP_HOME/."

# Layer 13. Указываем все команды, которые будут выполняться от имени app пользователя
USER $APP_USER

# Layer 14. Запускаем команду для компиляции статических (JS и CSS) файлов
RUN bin/rails assets:precompile
```

--

Команда по умолчанию

```bash
# Dockerfile

# Layer 15. Указываем команду по умолчанию для запуска будущего контейнера. По скольку в `Layer 13` мы переопределили пользователя, то puma сервер будет запущен от имени www-data пользователя.
CMD bundle exec puma -C config/puma.rb
```

--

![dockerfile-layers.png](/assets/images/docker/dockerfile-layers.png)

--

## .dockerignore

Иногда нужно избежать добавления определенных файлов в образ приложения, например secrets files или файлов, которые относятся только к локальному окружению.

```
.git
/log/*
/tmp/*
!/log/.keep
!/tmp/.keep
!/tmp/pids/.keep
/vendor/bundle
/public/assets
/config/master.key
/.bundle
/venv
```

--

## Запуск

```bash
# -t задает тег образу. Добавление тегов к образам помогает лучше идентифицировать образ из всех имеющихся.
docker build -t spreeproject_server_app .
```

Другие [полезные команды](https://docs.docker.com/compose/reference) для работы с образами.


