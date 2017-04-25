---
layout: slide
title: Capistrano
---

![](/assets/images/capistrano.svg)

# Capistrano

---

# What is Capistrano?

Capistrano is a remote server automation tool built on Ruby, Rake, and SSH.

Capistrano is a framework for building automated deployment scripts. Although Capistrano itself is written in Ruby, it
can easily be used to deploy projects of any language or framework, be it Rails, Java, or PHP.

--

## Capistrano can be used to:

> - Reliably deploy web application to any number of machines simultaneously, in sequence or as a rolling set
> - To automate audits of any number of machines (checking login logs, enumerating uptimes, and/or applying security patches)
> - To script arbitrary workflows over SSH
> - To automate common tasks in software teams.

---

# Install the Capistrano

Gemfile <!-- .element: class="filename" -->

```ruby
group :development do
  gem 'capistrano', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano3-puma', require: false
end
```

```bash
bundle install
```
<!-- .element: class="command-line" -->

--

## Capify your project

```bash
cap install
```
<!-- .element: class="command-line" -->

This creates all the necessary configuration files and directory structure for a Capistrano-enabled project with two
stages: `staging` and `production`:

```
├── Capfile
├── config
│   ├── deploy
│   │   ├── production.rb
│   │   └── staging.rb
│   └── deploy.rb
└── lib
    └── capistrano
            └── tasks
```

---

# Structure

> Capistrano uses a strictly defined directory hierarchy on each remote server to organise the source code and other
  deployment-related data.

```text
├── current -> /home/deployer/blog/releases/20150120114500/
├── releases
│   ├── 20150080072500
│   ├── 20150090083000
│   ├── 20150100093500
│   ├── 20150110104000
│   └── 20150120114500
├── repo
│   └── <VCS related data>
├── revisions.log
└── shared
    └── <linked_files and linked_dirs>
```

--

# Structure

- `current` is a symlink pointing to the latest release. This symlink is updated at the end of a successful deployment.
  If the deployment fails in any step the current symlink still points to the old release.

- `releases` holds all deployments in a timestamped folder. These folders are the target of the current symlink.

- `repo` holds the version control system configured. In case of a git repository the content will be a raw git
  repository (e.g. objects, refs, etc.).

- `revisions.log` is used to log every deploy or rollback. Each entry is timestamped and the executing user (username
  from local machine) is listed. Depending on your VCS data like branchnames or revision numbers are listed as well.

- `shared` contains the linked_files and linked_dirs which are symlinked into each release. This data persists across
  deployments and releases. It should be used for things like database configuration files and static and persistent
  user storage handed over from one release to the next.

---

# Configuration

Configuration variables can be either global or specific to your stage.

- Global: `config/deploy.rb`
- Stage specific: `config/deploy/<stage_name>.rb`

---

# Variables

- `:application` - The name of the application.
- `:deploy_to` - The path on the remote server where the application should be deployed.
- `:scm` - The Source Control Management used. Currently :git, :hg and :svn are supported.
- `:repo_url` - URL to the repository.
- `:branch` - The branch name to be deployed from SCM.
- `:linked_files` - Listed files will be symlinked from the shared folder of the application into each release directory during deployment. Can be used for persistent configuration files like **database.yml**.
- `:linked_dirs` - Listed directories will be symlinked into the release directory during deployment. Can be used for persistent directories like uploads or other data.
- `:default_env` - Default shell environment used during command execution. Can be used to set or manipulate specific environment variables (e.g. $PATH and such).
- `:keep_releases` - The last `n` releases are kept for possible rollbacks. The cleanup task detects outdated release folders and removes them if needed.
- `:tmp_dir` - Temporary directory used during deployments to store data.
- `:local_user` - Username of the local machine used to update the revision log.
- `:pty` - Used in SSHKit.
- `:log_level` - Used in SSHKit.
- `:format` - Used in SSHKit.

---

# Flow

--

## Deploy flow

When you run `cap production deploy`, it invokes the following tasks in sequence:

```text
deploy:starting    - start a deployment, make sure everything is ready
deploy:started     - started hook (for custom tasks)
deploy:updating    - update server(s) with a new release
deploy:updated     - updated hook
deploy:publishing  - publish the new release
deploy:published   - published hook
deploy:finishing   - finish the deployment, clean up everything
deploy:finished    - finished hook
```

--

## Rollback flow

When you run `cap production deploy:rollback`, it invokes the following tasks in sequence:

```text
deploy:starting
deploy:started
deploy:reverting           - revert server(s) to previous release
deploy:reverted            - reverted hook
deploy:publishing
deploy:published
deploy:finishing_rollback  - finish the rollback, clean up everything
deploy:finished
```

---

# Tasks

--

## Tasks

```ruby
server 'example.com', roles: [:web, :app]
server 'example.org', roles: [:db, :workers]

desc 'Report Uptimes'
task :uptime do
  on roles(:all) do |host|
    execute :any_command, 'with args', :here, 'and here'
    info "Host #{host} (#{host.roles.to_a.join(', ')}):\t#{capture(:uptime)}"
  end
end
```

--

## Local Tasks

Local tasks can be run by replacing on with `run_locally`:

```ruby
desc 'Notify service of deployment'
task :notify do
  run_locally do
    with rails_env: :development do
      rake 'service:notify'
    end
  end
end
```

Of course, you can always just use standard ruby syntax to run things locally:

```ruby
desc 'Notify service of deployment'
task :notify do
  %x('RAILS_ENV=development bundle exec rake "service:notify"')
end
```

Alternatively you could use the rake syntax:

```ruby
desc "Notify service of deployment"
task :notify do
   sh 'RAILS_ENV=development bundle exec rake "service:notify"'
end
```

---

# Hooks

--

## Before / After Hooks

Where calling on the same task name, executed in order of inclusion

```ruby
# call an existing task
before :starting, :ensure_user

after :finishing, :notify

# or define in block
before :starting, :ensure_user do
  # ...
end

after :finishing, :notify do
  # ...
end
```

---

# Command-line usage

```bash
cap -T
# list all available tasks

cap staging deploy
# deploy to the staging environment

cap production deploy
# deploy to the production environment

cap production deploy --dry-run
# simulate deploying to the production environment does not actually do anything

cap production deploy --trace
# trace through task invocations

cap production doctor
# display a Capistrano troubleshooting report

cap --roles=app,web production deploy
# run tasks only for specific roles

cap production deploy:rollback
# rollback to previous release
```
<!-- .element: class="command-line" data-output="2-3,5-6,8-9,11-12,14-15,17-18,20-21,23"-->

---

# Let's start to configure

--

## Capfile

Capfile <!-- .element: class="filename" -->

```ruby
# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# Load the SCM plugin
require 'capistrano/scm/git'

install_plugin Capistrano::SCM::Git

# Include tasks from other gems
require 'capistrano/rails'     # https://github.com/capistrano/rails
require 'capistrano/puma'      # https://github.com/seuros/capistrano-puma
require 'airbrussh/capistrano' # https://github.com/mattbrictson/airbrussh

install_plugin Capistrano::Puma

# Load custom tasks from `lib/capistrano/tasks' if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
```

--

## Capistrano config

config/deploy.rb <!-- .element: class="filename" -->

```ruby
lock '3.8.1'

set :application, 'Blog'

set :repo_url, "git@github.com:timlar/capistrano-example-for-rubygarage-course.git"
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :deploy_to, '/home/deployer/blog'

append :linked_files, *%w(
  config/database.yml
  config/secrets.yml
)

append :linked_dirs, *%w(
  log
  public/system
  public/uploads
  tmp/cache
  tmp/pids
  tmp/sockets
  vendor/bundle
)

set :keep_releases, 5

# Puma config
set :puma_init_active_record, true
set :puma_preload_app, true
```

--

## Production config

config/deploy/production.rb <!-- .element: class="filename" -->

```ruby
# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server "example.com", user: "deploy", roles: %w{app db web}, my_property: :my_value
# server "example.com", user: "deploy", roles: %w{app web}, other_property: :other_value
# server "db.example.com", user: "deploy", roles: %w{db}

server '138.68.79.104', user: 'deployer', roles: %w(app db web), primary: true



# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

# role :app, %w{deploy@example.com}, my_property: :my_value
# role :web, %w{user1@primary.com user2@additional.com}, other_property: :other_value
# role :db,  %w{deploy@example.com}



# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.

set :stage, :production
set :rails_env, :production
set :branch, :master


# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# The server-based syntax can be used to override options:
# ------------------------------------
# server "example.com",
#   user: "user_name",
#   roles: %w{web app},
#   ssh_options: {
#     user: "user_name", # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: "please use keys"
#   }

set :ssh_options, forward_agent: true,
                  user: 'deployer',
                  auth_methods: %w(publickey)
```

--

## Puma config

To upload puma config use:

```bash
cap production puma:config
```
<!-- .element: class="command-line" -->

By default the file located in `shared/puma.config`

--

## Check configuration

```bash
cap production deploy:check

...

00:11 deploy:check:linked_files
      ERROR linked file /home/deployer/blog/shared/config/application.yml does not exist on 104.236.216.96
```
<!-- .element: class="command-line" data-output="2-6" -->

--

## Create configuration files

config/database.production.yml <!-- .element: class="filename" -->

```yaml
default: &default
  adapter: postgresql
  encoding: unicode

production:
  <<: *default
  database: blog_production
  username: deployer
  password: deployer
```

config/secrets.production.yml <!-- .element: class="filename" -->

```yaml
production:
  secret_key_base: aea1e00b71fdc723f46ecafa8d0e4be62cf340e3a506097369c587a8f6b63f60bf437c04567e085a6015a27149a5f90143d9c4a3d9950794d0d1712d4e2c78c2
```

Add this files to `.gitignore`

```bash
echo "config/database.production.yml\nconfig/secrets.production.yml" >> .gitignore
```

---

## A task for uploading
## config files

lib/capistrano/tasks/upload_configs.rake <!-- .element: class="filename" -->

```ruby
namespace :deploy do
  desc 'Upload config files'
  task upload_configs: ['deploy:check:linked_dirs'] do
    on roles(:all) do
      execute "mkdir -p #{shared_path}/config"
      upload! 'config/database.production.yml', "#{deploy_to}/shared/config/database.yml"
      upload! 'config/secrets.production.yml', "#{deploy_to}/shared/config/secrets.yml"
    end
  end
end
```

And execute the following command to upload config files:

```bash
cap production deploy:upload_configs
```
<!-- .element: class="command-line" -->

---

# Let's deploy!

```ruby
cap production deploy
```
<!-- .element: class="command-line" -->

---

# Documentation

- [Capistrano](http://capistranorb.com)
- [Capistrano (GitHub)](https://github.com/capistrano/capistrano)
- [Capistrano Puma (GitHub)](https://github.com/seuros/capistrano-puma)

---

# The End
