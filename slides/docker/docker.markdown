---
layout: slide
title: Docker
---

## Проблемы

- Неудачи при попытке установить все зависимое ПО, при этом не "сломав" ничего локально
- Непонимание, как запустить приложение
- Несоответствие локальной инфраструктуры с удаленной
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

Docker строится на контейнеризации приложений в изолированной среде.

![logo.jpeg](/assets/images/docker/docker/docker_main.png)

--

## Образы и контейнеры

Образ — это пакет, который включает в себя все необходимые для запуска приложения

Контейнер — это экземпляр образа вашего приложения во время выполнения.

---

## Виртуальная машина и Docker контейнер

--

## Виртуальная машина

![docker-vm](/assets/images/docker/docker/vm.png)

Виртуальной машина предоставляет среде больше ресурсов, чем требуется большинству приложений

--

## Docker контейнер

![docker-container](/assets/images/docker/docker/dm.png)

Контейнер работает в Linux и разделяет ядро HostOS с другими контейнерами. Он запускается в отдельном процессе, занимая минимум памяти

---

## Образ и слои

![image-layer](/assets/images/docker/docker/docker_layer.png)

Dockerfile состоит из команд (RUN, ENTRYPOINT, CMD и другие). 

Каждая команда создание нового слоя при сборке образа.

Структура связей между слоями в Docker - иерархическая.

--

![dockerfile.png](/assets/images/docker/docker/dockerfile_description.png)

--

## Dockerfile

![dockerfile.png](/assets/images/docker/docker/dockerfile.png)

Это [инструкция](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#dockerfile-instructions) для сборки образ вашего ПО

--

## Контейнер и слои

![conainers-layer](/assets/images/docker/docker/container_layer.png)

Когда запускается контейнер, он создает еще один слой поверх образа

Только слой контейнера доступен для **записи**

--

## Контейнеры и волумы

![volumes.png](/assets/images/docker/docker/volumes.png)

Docker volume – папка на HostOS, "примонтированная" к файловой системе контейнера

---

![development](/assets/images/docker/docker/development.png)

--

![docker-components](/assets/images/docker/docker-compose.png)

Docker Compose - это инструмент для определения и запуска многоконтейнерных приложений Docker.

--

Возможности Compose:

- Запуск нескольких изолированных сред на одном хосте

- Настройка volumes при создании контейнеров

- Удобный менеджмент запущенных контейнеров

- Удобная конфигурация контейнеров и коммуникации между ними

--

## docker-compose.yml

С Compose вы используете файл YAML для настройки сервисов(контейнеров) вашего приложения и одну команду для создания и запуска всех сервисов из этого файла конфигурации

![docker-compose-example](/assets/images/docker/docker/docker-compose.png)

--

## Задание

- Развернем наше Web-приложение локально с помощью Docker и Docker-compose.
- Развернем staging-окружение приложения на AWS.
- Развернем production-окружение приложения на AWS.
- Настроим тестовое окружение и continuous integration для staging и production окружения с помощью CircleCI.

## [Решение](https://dou.ua/lenta/articles/rails-tutorial-docker-1)
