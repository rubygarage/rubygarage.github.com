---
layout: slide
title: CircleCi
---

# CircleCI

--

![](/assets/images/circleci/circleci-logo-stacked-fb.png)

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

in version `2.1` you can use `executor`
```yml
executors:
  default:
    docker:
      - image: circleci/ruby:2.6.1-node-browsers
      - image: circleci/postgres:11.3-alpine
```

---

# Environment variables

--
## Setting an Environment Variable in a Step, Job, Container

.circleci/config.yml<!-- .element: class="filename" -->
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

--

## **Remember!** 

Do not add secrets or keys inside the `.circleci/config.yml` file. 

The full text of `config.yml` is visible to developers with access to your project on CircleCI.

Store secrets or keys in [project](https://github.com/rubygarage/circledge/blob/master/intro_to_circleci.md#setting-an-environment-variable-in-a-project) or [context](https://github.com/rubygarage/circledge/blob/master/intro_to_circleci.md#setting-an-environment-variable-in-a-context) settings in the CircleCI app.


---

# Caching

--

![](/assets/images/circleci/why_not_cache_it.jpeg)

**Caching** is one of the most effective ways to make jobs faster on CircleCI by reusing the data from expensive fetch operations from previous jobs.

A good example is package dependency managers such as Yarn, Bundler, or Pip. With dependencies restored from a cache, commands like yarn install will only need to download new dependencies, if any, and not redownload everything on every build.


--

## Сache saving example

.circleci/config.yml<!-- .element: class="filename" -->
```yml
    steps:
      - restore_cache:
          keys:
            - source-v1-{{ checksum "Gemfile.lock" }}
            - source-v1-

      - run: bundle install --path vendor/bundle

      - save_cache:
          key: source-v1-{{ checksum "Gemfile.lock" }}
          paths:
            - vendor/bundle
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

--

## Additional info about cache

- Сache is stored on the local machine CircleCi

- 1 month cache lifetime

- Use `cache` key for define names of you cache. example:

```yml
caches: 
  - &bundle_cache v1-repo-{{ checksum "Gemfile.lock"  }}

commands:
  setup_env:
    steps:
      - checkout
      - restore_cache:
          key: *bundle_cache
```

---

# Steps

--

![](/assets/images/circleci/steps.png)

`Steps` are a collection of executable commands which are run during a job/command. 

If one step exit with code 1(failed), then the next ones will not be executed.

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

--
## Predefined steps:

- [checkout](https://circleci.com/docs/2.0/configuration-reference/#checkout)
- [save_cache](https://circleci.com/docs/2.0/configuration-reference/#save_cache)
- [restore_cache](https://circleci.com/docs/2.0/configuration-reference/#restore_cache)
- [persist_to_workspace](https://circleci.com/docs/2.0/configuration-reference/#persist_to_workspace)
- [attach_workspace](https://circleci.com/docs/2.0/configuration-reference/#attach_workspace)
- [add_ssh_keys](https://circleci.com/docs/2.0/configuration-reference/#add_ssh_keys)

--

## Best Practices

### Use predefined steps instead of defining steps in the job

Use:
```yml
commands:
  run_linters:
    steps:
      - run: bundle exec rubocop
      - run: bundle exec brakeman -q
jobs:
  build:
    executor: default
    steps:
      - run_linters
```
Instead:
```yml
jobs:
  build:
    executor: default
    steps:
      - run: bundle exec rubocop
      - run: bundle exec brakeman -q
```

more about steps you can see [here](https://github.com/rubygarage/circledge/blob/master/intro_to_circleci.md#steps)

---

# Jobs

--
### Job User Interface

![](/assets/images/circleci/job-ui.png)

**Job** is a collection of Steps. All of the steps in the job are executed in a single unit which consumes a CircleCI container from your while it’s running.

--

## Job rules:

- If you are using Workflows, jobs must have a name that is unique within the `.circleci/config.yml` file.

- If you are **not** using workflows, the jobs map must contain a job named `build`. This `build` job is the default entry-point for a run that is triggered by a push to your VCS provider.

--
## Sample of job:

.circleci/config.yml<!-- .element: class="filename" -->
```yml
jobs:
  lintering:
    executor: default
    steps:
      - setup_environment
      - run_linters
```

more about job you can see [here](https://github.com/rubygarage/circledge/blob/master/intro_to_circleci.md#jobs)

---

# Workflows

--

![](/assets/images/circleci/workflow.png)

A **workflow** is a set of rules for defining a collection of jobs and their run order.

--

## With workflows, you can:

- Run and troubleshoot jobs independently with real-time status feedback.
- Schedule workflows for jobs that should only run periodically.
- Fan-out to run multiple jobs in parallel for efficient version testing.
- Fan-in to quickly deploy to multiple platforms.

--

## Sample of workflow:

.circleci/config.yml<!-- .element: class="filename" -->
```yml
workflows:
  version: 2.1
  build:
    jobs:
      - lintering
      - run_specs:
          requires:
            - lintering
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

.circleci/config.yml<!-- .element: class="filename" -->
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

![](/assets/images/circleci/ci_artifacts.png)

---

# Project Configuration

--

## Overview

To support the open source community, projects that are public on GitHub or Bitbucket receive three free build containers, for a total of four containers. 

Only one container is available for private repositories

--

## Only Build Pull Requests

By default, CircleCI builds every commit from every branch. 

This behavior may be too aggressive for open source projects, which often have significantly more commits than private projects. 

To change this setting, go to the Advanced Settings of your project and set the Only build pull requests option to On.

--

## Auto-cancel redundant builds

Automatically closes all old build for some branch/PR if there is a newer one

Pipelines must be enabled in order to use this feature.

--

## Recommended configurations:

- ✓ Auto-cancel redundant builds
- ✓ Only build pull requests
- ✓ GitHub Status updates
- ✓ Enable pipelines

---

# Debugging with SSH

--

![](/assets/images/circleci/ssh-client-server.jpg)

Often the best way to troubleshoot problems is to SSH into a job and inspect things like log files, running processes, and directory paths.

### How to connect via SSH see [here](https://github.com/rubygarage/circledge/blob/master/debugging_with_ssh.md)

---
# Parallelism

--

If your project has a large number of tests, it will need more time to run them on one machine. 

To reduce this time, you can run tests in parallel by spreading them across multiple machines. 

![](/assets/images/circleci/test_splitting.png)

--
To run a job’s steps in parallel, set the `parallelism` key to a value greater than 1.

example:

```yml
jobs:
  lintering:
    executor: default
    steps:
      - defaults
      - run_linters
  run_specs:
    executor: default
    parallelism: 2
    steps:
      - defaults
      - run_specs
```
---

# Orbs

--

**CircleCI Orbs** are shareable packages of configuration elements, including jobs, commands, and executors. 

CircleCI provides certified orbs, along with 3rd-party orbs authored by CircleCI partners. 

It is best practice to first evaluate whether any of these existing orbs will help you in your configuration workflow.

Refer to the [CircleCI Orbs Registry](https://circleci.com/orbs/registry/) for the complete list of certified orbs.

--

## Orb Structure

Orbs consist of the following elements:

- Commands
- Jobs
- Executors

You can read about each of this features [here](https://github.com/rubygarage/circledge/blob/master/version_2_1.md)

--

## Sample of using orbs:

Before using the orb, you need to read the documentation for use which can be found on the main page of the orb

example of usage: 

.circleci/config.yml<!-- .element: class="filename" -->
```yml
version: 2.1
orbs:
  hello-build: circleci/hello-build@0.0.9
workflows:
  build:
    jobs:
      - hello-build/hello-build
```
--

## How to create your own orb see [here](https://github.com/rubygarage/circledge/blob/master/orbs.md#creating-a-circleci-orb)

---

# Special Cases

--

## Coverage per several threads

When we separate tests into different containers, the problem of correctly displaying the percentage of covered code.

How to merge coverage from different containers see [here](https://github.com/rubygarage/circledge/blob/master/special_cases.md#coverage-per-several-threads).

--

## Approvable Deployment

We can use approvable deployment when we need us to choose which build will be deployed.

How to setup approvable deployment see [here](https://github.com/rubygarage/circledge/blob/master/special_cases.md#approvable-deployment).

--

## Daily Builds

You can configure daily builds to ensure that there are no phantom tests

How to setup daily builds see [here](https://github.com/rubygarage/circledge/blob/master/special_cases.md#daily-builds)

--

## Heroku continuous deployment

How to setup continuous deployment on Heroku see [here](https://github.com/rubygarage/circledge/blob/master/special_cases.md#heroku-continuous-deployment).

---

# Sample of CircleCi config

--
.circleci/config.yml<!-- .element: class="filename" -->
```yml
version: 2.1

executors:
  default:
    working_directory: ~/repo
    description: The official CircleCI Ruby Docker image
    docker:
      - image: circleci/ruby:2.6.1-node-browsers
        environment:
          RAILS_ENV: test
      - image: circleci/postgres:11.3-alpine
        environment:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres

caches: 
  - &bundle_cache v1-repo-{{ checksum "Gemfile.lock" }}

commands:
  run_linters:
    description: command to start linters
    steps:
      - run: 
          name: rubocop
          command: bundle exec rubocop
      - run: 
          name: brakeman
          command: bundle exec brakeman -q
      - run: 
          name: lol_dba
          command: bundle exec lol_dba db:find_indexes
      - run: 
          name: rails best prctices
          command: bundle exec rails_best_practices .

  run_specs:
    steps:
      - run: 
          name: run specs
          command: |
            mkdir /tmp/test-results
            TEST_FILES="$(circleci tests glob "spec/**/*_spec.rb" | circleci tests split --split-by=timings)"
            bundle exec rspec --format progress \
                              --out /tmp/test-results/rspec.xml \
                              $TEST_FILES
  setup_environment:
    steps:
      - checkout
      - restore_cache:
          key: *bundle_cache
      - run: bundle install --path vendor/bundle
      - save_cache:
          key: *bundle_cache
          paths:
            - vendor/bundle
      - run:
          name: Set up DB
          command: |
            bundle exec rake db:create
            bundle exec rails db:schema:load
jobs:
  lintering:
    executor: default
    steps:
      - setup_environment
      - run_linters
  run_specs:
    executor: default
    steps:
      - setup_environment
      - run_specs

workflows:
  version: 2.1
  build:
    jobs:
      - lintering
      - run_specs:
          requires:
            - lintering
```

---

# Control questions

- How to connect CircleCi to GitHub?

- How to set the environment? What is an image and what are they? What are the best practices for using images?

- How to set environment variables? Where can I set the variable so that it is not visible to other users?

- What is a job? What can they contain?  What are the best practices for using jobs?

- What is step? What pre-defined steps do you know? What are the best practices for using step?

- What is workflow? What are the pros and cons of using more than one `job` in workflow?

- What is caching for? What should be cached in Rails applications?  What are the best practices for using caching?

- What are artifacts? What are they used for?

- What are orbs? How to use orbs?
