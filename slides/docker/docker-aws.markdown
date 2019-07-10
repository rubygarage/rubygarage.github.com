---
layout: slide
title: Amazon ECS
---

## Что такое ECS?

![amazon_ecs](/assets/images/docker/amazon_ecs.png)

Это высокомасштабируемый, высокопроизводительный сервис оркестрации контейнеров, который поддерживает Docker и позволяет легко запускать и масштабировать контейнерны ваших приложений в AWS.

--

### Похожие инструменты:
- Kubernetes
- Docker Swarm
- Azure Container Service.

---

## Terms and architecture

![ecs_architect](/assets/images/docker/ecs_architect.jpeg)

--

- Container Instance. EC2 инстанс, который связан с Cluster
- Container Agent. Сервис, который подвязывает EC2 инстансы к Custer.
- Cluster. Группа связанных между собой EC2 инстансов и Service-ов.
- ECR. Приватный репозиторий на котором будут храниться докер образы нашего приложения.
- Task definition. Инструкция по запуску контейнеров на EC2.
- Task. Один или несколько запущенных контейнеров.
- Service. Совокупность запущенных Tasks.

--

## Task Definition

Это инструкция описывающаю как и какие Docker контейнеры вашего приложения должны быть запущенны

--

## Task

![ecs_task](/assets/images/docker/ecs_task.png)

Это экземпляр Task Definition, характеризующий запущенный контейнер в нем. С помощью одной Task Definition может быть запущенно несколько Task

--

## Service

![ecs_service](/assets/images/docker/ecs_service.png)

Группу запущенных Task мы можем объединить в Service, для дальнейшего масштабирования и распределния нагрузки с помощью [Amazon ELB](https://aws.amazon.com/elasticloadbalancing)

--

## Cluster

![ecs_cluster](/assets/images/docker/ecs_cluster.png)

Группу запущенных Task мы можем объединить в Service, для дальнейшего масштабирования и распределния нагрузки с помощью [Amazon ELB](https://aws.amazon.com/elasticloadbalancing)
