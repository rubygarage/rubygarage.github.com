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

---

# Docker commands

--

#  Pull image from DockerHub
<br>

```bash
docker pull hello-world
```

--

# Run image. If image not exists locally then pull it from DockerHub
<br>

```bash
docker run hello-world
```

--

# Build image from the Dockerfile
<br>

```bash
docker build -t <image_tag> - < Dockerfile
```

and then you can run it in interactive mode:

```bash
docker run -it <image_tag> bash
```

or run in deamon mode

```bash
docker run -d <image_tag> rails s
```

or just run, execute command and stop

```bash
docker run <image_tag> uname -a
```

--

# Display running containers
<br>

```bash
docker ps
```

If you want to see all containers - live and dead, so just add `-a` to commant:

```bash
docker ps -a
```

--

# Execute command in running container

You can run command and get output:
```bash
docker exec <container_id or name> some command
```

or run command in interactive mode:
```bash
docker exec -it <container_id or name> rails c
```

--

# Managing images
<br>

## List images
<br>

```bash
docker images ls
```

## Remove image
<br>

```bash
docker rmi <image_id or tag>
```

--

# Managing volumes
<br>

## List volumes
<br>

```bash
docker volume ls
```

## Create volume
<br>

```bash
docker volume create <name>
```

## Remove volume
<br>

```bash
docker volume rm <name>
```

--

## Delete everything (containers, images, volumes, networks) in one command
<br>

```bash
docker system prune -af
```
#### Be very careful with this command!

--

# Inspect container logs
<br>

```bash
docker logs <container_id or name>
```

--

# Inspect container metadata
<br>

```bash
docker inspect <container_id or name>
```

---

# Docker Compose commands

--

# Build images
<br>

```bash
docker-compose build
```

--

# Run containers
<br>

```bash
docker-compose up
```

--

# Build and run containers
<br>

```bash
docker-compose up --build
```

--

# Stop all containers
<br>

```bash
docker-compose down
```

---

# Popular questions

--

## How to seed DB in container?
<br>

Let's image that you already have running containers, but empty database,
so to seed you just need to execute one command:
```bash
docker exec -it <rails_container_id> rake db:seed
```

--

## How to debug dockerized application?
<br>

Just attach to the running rails container
```bash
docker attach <rails_container_id>
```
and magic...

---

# Usefull links

--

## Documentation:

[DockerHub](https://hub.docker.com/)

[Docker build docs](https://docs.docker.com/engine/reference/commandline/build/)

[Docker run docs](https://docs.docker.com/engine/reference/commandline/run/)

[Docker volume docs](https://docs.docker.com/storage/volumes/)

[Docker compose docs](https://docs.docker.com/compose/)

[Docker security docs](https://docs.docker.com/engine/security/)

--

## Courses

[Official docker course](https://www.docker.com/play-with-docker)

[Docker interactive course](https://www.katacoda.com/courses/docker)

--

## Utils

A tool for exploring a docker image, layer contents, and discovering ways to shrink the size of your Docker/OCI image:

[Dive](https://github.com/wagoodman/dive)

<br>

The Docker Bench for Security is a script that checks for dozens of common best-practices around deploying Docker containers in production:

[Docker Bench Security](https://github.com/docker/docker-bench-security)

<br>

VScode extension

[Link](https://code.visualstudio.com/docs/containers/overview)

--

# Materials from this lecture

https://github.com/bl0rch1d/docker_lecture_materials

---

# One more thing...

---

```bash
git clone https://github.com/bl0rch1d/docker_lecture_materials.git

cd docker_lecture_materials

docker build -t sw_movie - < ./dockerfiles/simple.Dockerfile

docker run -it sw_movie telnet towel.blinkenlights.nl
```
