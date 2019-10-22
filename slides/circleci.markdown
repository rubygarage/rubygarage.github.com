---
layout: slide
title: CircleCi
---

# CircleCI

--

Continuous integration [service](https://circleci.com/) for web and mobile applications. The service allows you to flexibly configure assembly testing.

CircleCI integrates with a VCS and automatically runs a series of steps every time that it detects a change to your repository.

---

# Executors and Images

--

## CircleCI enables you to run jobs in one of four environments:

- Within Docker images (docker)
- Within a Linux virtual machine (VM) image (machine)
- Within a macOS VM image (macos)
- Within a Windows VM image

--

## Language Images
Language images are convenience images for common programming languages. These images include both the relevant language and commonly-used tools. A language image should be listed first under the docker key in your configuration, making it the primary container during execution.

--

## CircleCI maintains images for the languages below.

- Android
- Clojure
- Elixir
- Go (Golang)
- JRuby
- Node.js
- OpenJDK (Java)
- PHP
- Python
- Ruby
- Rust

--

## Service Images
Service images are convenience images for services like databases. These images should be listed after language images so they become secondary service containers.

--
## CircleCI maintains images for the services below.

- DynamoDB
- MariaDB
- MongoDB
- MySQL
- PostgreSQL
- Redis

--

## Sample Configuration
```yml
version: 2
jobs:
  build:
    docker:
      - image: circleci/ruby:2.6.1-node
      - image: circleci/postgres:11.5
      - image: redis
```

---

# Environment variables

--

## **Remember!** 

Do not add secrets or keys inside the `.circleci/config.yml` file. The full text of `config.yml` is visible to developers with access to your project on CircleCI. Store secrets or keys in [project](https://github.com/rubygarage/circledge/blob/master/intro_to_circleci.md#setting-an-environment-variable-in-a-project) or [context](https://github.com/rubygarage/circledge/blob/master/intro_to_circleci.md#setting-an-environment-variable-in-a-context) settings in the CircleCI app.

--
## Setting an Environment Variable in a Step, Job, Container
```yml
version: 2
jobs:
  build:
    docker:
      - image: smaant/lein-flyway:2.7.1-4.0.3
      - image: circleci/postgres:9.6-jessie
      # environment variables for the container in which were defined
        environment:
          POSTGRES_USER: conductor
          POSTGRES_DB: conductor_test
  # environment variables for all commands executed in the job
    environment:
      JOB_VARIABLE: 'foo'
    steps:
      - checkout
      - run:
          name: Run migrations
          command: sql/docker-entrypoint.sh sql
          # Environment variable for a single command shell
          environment:
            DATABASE_URL: postgres://conductor:@localhost:5432/conductor_test
```

--

## Built-in Environment Variables
The built-in environment variables are exported in each build and can be used for more complex testing or deployment.

The list of buil-in variables you can see [here](https://circleci.com/docs/2.0/env-vars/#built-in-environment-variables)

---

# Caching

--

Caching is one of the most effective ways to make jobs faster on CircleCI by reusing the data from expensive fetch operations from previous jobs.

A good example is package dependency managers such as Yarn, Bundler, or Pip. With dependencies restored from a cache, commands like yarn install will only need to download new dependencies, if any, and not redownload everything on every build.

Automatic dependency caching is not available in CircleCI 2.0, so it is important to plan and implement your caching strategy to get the best performance. Manual configuration in 2.0 enables more advanced strategies and finer control.

--

## Сache saving example

```yml
    steps:
      - restore_cache:
          keys:
            - source-v1-{{ .Branch }}-{{ .Revision }}
            - source-v1-{{ .Branch }}-
            - source-v1-

      - checkout

      - save_cache:
          key: source-v1-{{ .Branch }}-{{ .Revision }}
          paths:
            - ".git"
```

--

## Clearing Cache

In order to clear the cache, you need to change the name of the key under which it is stored for example:
```yml
  - v1-npm-deps-{{ checksum "package-lock.json" }} 
```
change to
```yml
  - v2-npm-deps-{{ checksum "package-lock.json" }}
```

---

# Steps

--

`Steps` are a collection of executable commands which are run during a job. The steps setting in a job should be a list of single key/value pairs, the key of which indicates the step type. The value may be either a configuration map or a string (depending on what that type of step requires).

--

Example, using a map:
```yml
jobs:
  build:
    steps:
      - run:
          name: Running tests
          command: make test
```
Example, using a string (name here will have the same value as command):
```yml
jobs:
  build:
    steps:
      - run: make test
```

more about steps you can see [here](https://github.com/rubygarage/circledge/blob/master/intro_to_circleci.md#steps)

---

# Jobs

--

**Job** is a collection of Steps. All of the steps in the job are executed in a single unit which consumes a CircleCI container from your while it’s running.

If you are using Workflows, jobs must have a name that is unique within the `.circleci/config.yml` file.

If you are **not** using workflows, the jobs map must contain a job named `build`. This `build` job is the default entry-point for a run that is triggered by a push to your VCS provider.

Jobs have a maximum runtime of 5 hours. If your jobs are timing out, consider running some of them in parallel.

--
## Sample of job:
```yml
jobs:
  lintering:
    executor: default
    steps:
      - defaults
      - run_linters
```

more about job you can see [here](https://github.com/rubygarage/circledge/blob/master/intro_to_circleci.md#jobs)

---

# Workflows

--

A **workflow** is a set of rules for defining a collection of jobs and their run order. Workflows support complex job orchestration using a simple set of configuration keys to help you resolve failures sooner.

With workflows, you can:

- Run and troubleshoot jobs independently with real-time status feedback.
- Schedule workflows for jobs that should only run periodically.
- Fan-out to run multiple jobs in parallel for efficient version testing.
- Fan-in to quickly deploy to multiple platforms.

--
## Sample of workflow:
```yml
workflows:
  version: 2
  build_and_test:
    jobs:
      - build
      - test
```
more about workflow [here](https://github.com/rubygarage/circledge/blob/master/intro_to_circleci.md#workflows)

---

# Artifacts

--

**Artifacts** persist data after a job is completed and may be used for longer-term storage of the outputs of your build process. You can store artifacts with `store_artifacts`

Currently, `store_artifacts` has two keys:

- path is a path to the file or directory to be uploaded as artifacts.

- destination (Optional) is a prefix added to the artifact paths in the artifacts API. The directory of the file specified in path is used as the default.

--

## Usage example:
```yml
steps:
  - run: 
      name: run specs
      command: |
        bundle exec rspec 
  - store_artifacts:
      path: ~/repo/coverage
      destination: coverage
```

--

After the completion of the job, you can see the artifacts in the tab 'Artifacts' :

![](/assets/images/ci_artifacts.png)
