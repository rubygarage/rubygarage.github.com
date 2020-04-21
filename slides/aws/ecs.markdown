---
layout: slide
title: ECS
---

# Amazon Elastic Container Service

---

## What is ECS?

![](/assets/images/aws/ecs/logo.png)

**Amazon Elastic Container Service (Amazon ECS)** is a container orchestration service that makes it easy to manage Docker containers on a cluster (EC2 instance or serverless infrastructure by using Fargate).

- manage container-based application
- schedule the placement of containers across your cluster based on your resource needs
- create a consistent deployment and build experience, manage, and scale batch workloads

---

## Architecture

![](/assets/images/aws/ecs/architecture.png)

- **Cluster** - a logical grouping of tasks or services.
- **Service** - allows you to run and maintain a specified number of instances of a task definition simultaneously in cluster
- **Task definition** - configuration that is required to run Docker containers
- **Container definition** - Docker container

--

Some of the parameters you can specify in a **Task Definition** include:

- the Docker image to use with each container in your task
- how much CPU and memory to use with each task or each container within a task
- the launch type to use
- whether the task should continue to run if the container finishes or fails
- the command the container should run when it is started
- the IAM role that your tasks should use

---

## Fargate

![](/assets/images/aws/ecs/fargate.png)

**Fargate** is a technology used with ECS to run containers without having to manage servers or clusters of EC2 instances.

Pros:

- serverless (ves the need to provision and manage servers, configure clusters to run containers)
- helps to focus on designing and building your applications instead of managing the infrastructure
- containers are provisioned by the container spec (CPU / RAM)

Cons:

- has long startup times
- no persistent filesystem access
- pricing is based on the memory and CPU required to run tasks

---

## Elastic Load Balancer (ELB)

![](/assets/images/aws/ecs/elb.png)

**Elastic Load Balancing** is a tool to distribute traffic across the tasks in your service.

ECS services support such load balancer types:
- Application Load Balancer (route HTTP/HTTPS traffic)
- Network Load Balancer and Classic Load Balancer (route TCP traffic)

--

## Application Load Balancer (ALB)

**Application Load Balancer (ALB)** allows to run multiple instances of the same application on the same EC2 machine. ALB has a direct integration feature with ECS called "port mapping".

![](/assets/images/aws/ecs/alb.png)

---

## Auto Scaling

**Auto Scaling** enables you to configure automatic scaling for the AWS resources that are part of your application.

With Auto Scaling, you configure and manage scaling for your resources through a scaling plan. The scaling plan automatically scale your application’s resources. This ensures that you add the required computing power to handle the load on your application and then remove it when it's no longer required.

---

## Elastic Container Registry (ECR)

![](/assets/images/aws/ecs/ecr.png)

**Amazon Elastic Container Registry (Amamzon ECR)** is a fully-managed Docker container registry like a DockerHub that makes it easy for developers to store, manage, and deploy Docker container images.

- integrated with ECS, simplifying your development to production workflow.
- eliminates the need to operate your own container repositories.
- hosts your images in a highly available and scalable architecture, allowing you to reliably deploy containers for your applications.

---

## ECS Deployment

- Rolling Update
- Blue/Green Deployment

--

## Rolling Update

![](/assets/images/aws/ecs/rolling_update.png)

**Rolling Update** involves the service scheduler replacing the current running version of the container with the latest version.

--

## Blue/Green Deployment

![](/assets/images/aws/ecs/blue_green.png)

**Blue/Green Deployment** enables you to verify a new deployment of a service before sending production traffic to it.

---

## CloudWatch

![](/assets/images/aws/ecs/cloud_watch.png)

**CloudWatch** is a tool which collects and processes raw data from ECS into readable, near real-time metrics.

These statistics are recorded for a period of two weeks, so that you can access historical information and gain a better perspective on how your clusters or services are performing. ECS metric data is automatically sent to CloudWatch in 1-minute periods.
