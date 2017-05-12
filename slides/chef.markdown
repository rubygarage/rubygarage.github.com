---
layout: slide
title: Chef
---

![](/rubygarage/assets/images/chef.svg)

---

# Why you should automate your web infrastructure?

> Server setup is one of the most tedious and boring task, which we have to do again and again.

<br/>

- All of your configuration information is in one place
- You can set up servers instantly
- You can change things in one place
- You can create dev and test environments that are exact replicas of production

---

# Tools

> - Chef
> - Ansible
> - Puppet
> - Saltstack
> - Terraform
> - other less known

---

# What is Chef?

> `Chef` is both the name of a [company][chef_company] and the name of a [configuration management tool][chef]
  written in `Ruby` and `Erlang`. It uses a `pure-Ruby`, `domain-specific language` (DSL) for writing system
  configuration `recipes`. Chef is used to streamline the task of configuring and maintaining a company's servers, and
  can integrate with cloud-based platforms such as [Internap][internap], [Amazon EC2][amazon_ec2],
  [Google Cloud Platform][google_cloud_platform], [OpenStack][openstack], [SoftLayer][softlayer],
  [Microsoft Azure][microsoft_azure] and [Rackspace][rackspace] to automatically provision and configure new machines.

[chef_company]: https://en.wikipedia.org/wiki/Chef_(company)
[chef]: https://www.chef.io/chef/
[internap]: https://en.wikipedia.org/wiki/Internap
[amazon_ec2]: https://en.wikipedia.org/wiki/Amazon_EC2
[google_cloud_platform]: https://en.wikipedia.org/wiki/Google_Cloud_Platform
[openstack]: https://en.wikipedia.org/wiki/OpenStack
[softlayer]: https://en.wikipedia.org/wiki/SoftLayer
[microsoft_azure]: https://en.wikipedia.org/wiki/Microsoft_Azure
[rackspace]: https://en.wikipedia.org/wiki/Rackspace

---

# Short history

The company was founded as Opscode in 2008.

The project, was originally named "marionette", but the word was too long and cumbersome to type; the "recipe" format
that the modules were prepared in led to the project being renamed "Chef".

In February 2013, Opscode released version 11 of Chef. Changes in this release included a complete rewrite of the core
API server in Erlang.

---

# Why Chef?

<br/>

- Written in Ruby
- Idempotent: Safe to re run the script
- Thick Clients, Thin Server
- Rich collection of [recipes](https://supermarket.chef.io/) (3 220+)
- Integration with many popular cloud-based platforms

---

# The difference between
# Chef and Chef Solo

--

# Chef

> - You have a master Chef server to which all Chef client nodes connect to understand what they are comprised of.
> - Cookbooks are uploaded to the Chef server using the Knife command line tool.

--

# Chef Solo

> - You only have a single Chef client which uses a local json file to understand what it is comprised of.
> - Cookbooks are either saved locally to the client or referenced via URL to a tar archive.

---

# Why Chef Solo?

- Free
- Open Source
- Runs locally
- Does not require Chef-Server

---

# Terminology

- `Recipe` A set of instructions for preparing a particular dish
- `Cookbook` The base unit of configuration. It manages your Recipes
- `Data Bag` It is a global variables
- `Role` Contains run lists of Cookbooks
- `Environment` Defines Node environment
- `Node` Configuration of your Recipes for the Server
- `Knife` A tool to help you cook

---

# Let's begin to setup

--

Create `Gemfile` with the following content

```ruby
source 'https://rubygems.org'

gem 'knife-solo'
gem 'knife-solo_data_bag'
gem 'berkshelf'
gem 'foodcritic'
```

Install gems and init Chef

```bash
gem i bundler
bundle
knife solo init .
```
<!-- .element: class="command-line" -->

--

## The directory structure

```bash
tree -a -F -L 2 --dirsfirst

.
├── .chef/
│   └── knife.rb
├── cookbooks/
├── data_bags/
├── environments/
├── nodes/
├── roles/
├── site-cookbooks/
├── Berksfile
├── Gemfile
└── Gemfile.lock
```
<!-- .element: class="command-line" data-output="2-14" -->

---

# Gems

- [Knife Solo](https://github.com/matschaffer/knife-solo) -Knife-Solo adds a handful of Knife commands that aim to make working with chef-solo as powerful as chef-server

- [Knife Solo Data Bag](https://github.com/thbishop/knife-solo_data_bag) - A knife plugin to make working with data bags easier in a chef solo environment.

- [Berkshelf](https://docs.chef.io/berkshelf.html) - Berkshelf is a dependency manager for Chef cookbooks. With it, you can easily depend on community cookbooks and have them safely included in your workflow.

- [FoodCritic](http://www.foodcritic.io) - Foodcritic is a helpful lint tool you can use to check your Chef cookbooks for common problems.

---

# Set up Cookbooks

Insert the following content into `Berksfile`

```ruby
source 'https://supermarket.chef.io'

cookbook 'openssh'
cookbook 'sudo'
cookbook 'swap_tuning'
cookbook 'users'
```

Install cookbooks

```bash
berks install
```
<!-- .element: class="command-line" -->

--

## The directory structure

```bash
tree -a -F -L 2 --dirsfirst

.
├── .chef/
│   └── knife.rb
├── cookbooks/
├── data_bags/
├── environments/
├── nodes/
├── roles/
├── site-cookbooks/
├── Berksfile
├── Berksfile.lock    <---
├── Gemfile
└── Gemfile.lock
```
<!-- .element: class="command-line" data-output="2-16" -->

---

# Data Bags

> Data Bags contain information that needs to be shared among more than one node:

- Shared passwords
- License keys for software installs
- Shared lists of users and groups
- SSH keys
- Common settings

--

## Create Data Bag for the user `deployer`

Run the following command

```bash
knife solo data bag create users deployer
```
<!-- .element: class="command-line" -->

It will create a file `data_bags/users/deployer.json`

--

## Edit Data Bag

Insert the following code into the file

data_bags/users/deployer.json <!-- .element: class="filename" -->

```json
{
  "id": "deployer",
  "password": "",
  "ssh_keys": [],
  "groups": ["sudo" ,"sysadmin", "www-data"],
  "shell": "/bin/bash"
}
```

--

## User password

This command returns an encrypted password

```bash
openssl passwd -1 '1q2w3e4r5t6y'

$1$39cUODR9$vPSm83A7vkS6MadGEh6Fs0
```
<!-- .element: class="command-line" data-output="2-3" -->

--

## SSH Key

Generate ssh key

```bash
ssh-keygen -t rsa -C 'dmitriy.grechukha@gmail.com'

Generating public/private rsa key pair.
Enter file in which to save the key (/Users/timlar/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /Users/timlar/.ssh/id_rsa.
Your public key has been saved in /Users/timlar/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:6nB87K0nCD7pD+nicAkfI3u4Z3HuBuMk+LZkt5gMu30 dmitriy.grechukha@gmail.com
The key's randomart image is:
+---[RSA 2048]----+
|                 |
|                 |
|                 |
|                 |
|+ o     S        |
|o*=+oo o         |
|==BB=o+.o        |
| %B=E*.o...      |
|+*BB=oo o+.      |
+----[SHA256]-----+
```
<!-- .element: class="command-line" data-output="2-22" -->

```bash
cat ~/.ssh/id_rsa.pub

ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCjZ0BqU80UMqzqgwoXBDPLyS2DKC8gIYKJ5B5pM/jN+whiArvpOCwHsPcxMSJlBjlMnjbeKUobsn7gHftCZUoMtdC2aYYLPA3UihS9Mw8ZyhQ0ccId4ND7XcTG3n2habbdoOjbdVGsY/1aPYxMCUIGlDPFXi4pABIqzuJ/IvviIQ1cfq26WF8C1Ds2kZ7AEsHXJVxvXyi7HTzcHeK59CH9rFLEFioQwQYg7i9GqJ+q4kMSIW0mtjxetOELsVca3GgIAJRr/kcAShuQWpvWEcGP6R8AJurvoUCVeL3NKmCmLXa0w4Rq7x03HYySAW44MbzsYEtPMaKCcj1Q06VgwX/H dmitriy.grechukha@gmail.com
```
<!-- .element: class="command-line" data-output="2-3" -->

--

## Set password and SSH key

data_bags/users/deployer.json <!-- .element: class="filename" -->

```json
{
  "id": "deployer",
  "password": "$1$39cUODR9$vPSm83A7vkS6MadGEh6Fs0",
  "ssh_keys": [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCjZ0BqU80UMqzqgwoXBDPLyS2DKC8gIYKJ5B5pM/jN+whiArvpOCwHsPcxMSJlBjlMnjbeKUobsn7gHftCZUoMtdC2aYYLPA3UihS9Mw8ZyhQ0ccId4ND7XcTG3n2habbdoOjbdVGsY/1aPYxMCUIGlDPFXi4pABIqzuJ/IvviIQ1cfq26WF8C1Ds2kZ7AEsHXJVxvXyi7HTzcHeK59CH9rFLEFioQwQYg7i9GqJ+q4kMSIW0mtjxetOELsVca3GgIAJRr/kcAShuQWpvWEcGP6R8AJurvoUCVeL3NKmCmLXa0w4Rq7x03HYySAW44MbzsYEtPMaKCcj1Q06VgwX/H dmitriy.grechukha@gmail.com"
  ],
  "groups": ["sudo" ,"sysadmin", "www-data"],
  "shell": "/bin/bash"
}
```

---

# Ohai

> Ohai collects information regarding nodes. It is required to be present on every node, and is installed as part of
  the bootstrap process.

> The information gathered includes network and memory usage, CPU data, kernel data, hostnames, FQDNs, and other
  automatic attributes that need to remain unchanged during the chef-client run.

---

# Environments

> Environment is a way to map an organisation’s real-life workflow on what can be configured and managed when using
  server. Every organisation begins with a single environment – a so called _default environment – which cannot be
  modified (or deleted). Additional environments can be created to reflect each organisation’s patterns and workflow.
  Creating production, staging, testing, and development environments is a good example. An environment can be also
  associated with one (or more) cookbook versions.

--

## Production Environment

environments/production.json <!-- .element: class="filename" -->

```json
{
  "name": "production",
  "description": "Production environment",
  "chef_type": "environment",
  "json_class": "Chef::Environment",
  "default_attributes": { }
}
```

or

environments/production.rb <!-- .element: class="filename" -->

```ruby
name 'production'
description 'Production environment'

default_attributes {}
```

---

# Nodes

--

## Create node configuration

nodes/XXX.XXX.XXX.XXX.json <!-- .element: class="filename" -->

```json
{
  "environment": "production",
  "users": ["deployer"],
  "authorization": {
    "sudo": {
      "groups": ["deployer", "sysadmin", "www-data"],
      "users": ["deployer"],
      "passwordless": "false"
    }
  },
  "swap_tuning": {
    "minimum_size": 4096
  },
  "run_list": [
    "recipe[swap_tuning]",
    "recipe[sudo]",
    "recipe[users::sysadmins]"
  ],
  "automatic": {
    "ipaddress": "XXX.XXX.XXX.XXX"
  }
}
```

---

## Run Lists

> Run lists define what cookbooks a node will use. The run list is an ordered list of all cookbooks and recipes that
  the chef-client needs to pull from the Chef server to run on a node. Run lists are also used to define Roles, which
  are used to define patterns and attributes across nodes.

---

## Roles

> A Role is a way to define certain patterns and processes that exist across Nodes in an organization as belonging to a
  single job function. Each Role consists of zero (or more) attributes and a run-list. Each Node can have zero (or
  more) Roles assigned to it.

---

# Custom Cookbooks

---

## Create own cookbook

```bash
knife cookbook create my_cookbook -o site-cookbooks

** Creating cookbook my_cookbook in ./site-cookbooks
** Creating README for cookbook: my_cookbook
** Creating CHANGELOG for cookbook: my_cookbook
** Creating metadata for cookbook: my_cookbook
```
<!-- .element: class="command-line" data-output="2-6" -->

---

## The directory structure

```bash
tree -a -F --dirsfirst site-cookbooks/my_cookbook

.
├── attributes/
├── files/
│   └── default/
├── libraries/
├── providers/
├── recipes/
│   └── default.rb
├── resources/
├── templates/
│   └── default/
├── CHANGELOG.md
├── README.md
└── metadata.rb
```
<!-- .element: class="command-line" data-output="2-16" -->

--

## Metadata

> The `metadata.rb` file contains metadata information about the service. This includes basic information like the name
  of the cookbook and the version, but it also is the place where the dependency information is stored. If this
  cookbook depends on other cookbooks to be installed, it can list them in this file and chef will install and
  configure them prior to the current cookbook.

--

## Attributes

> The `attributes` directory contains attribute definitions that can be used to override or define settings for the
  nodes that will have this service.

--

## Attribute Precedence

Attributes are always applied by the chef-client in the following order:

1. A `default` attribute located in an attribute file
2. A `default` attribute located in a recipe
3. A `default` attribute located in an environment
4. A `default` attribute located in role
5. A `force_default` attribute located in an attribute file
6. A `force_default` attribute located in a recipe
7. A `normal` attribute located in an attribute file
8. A `normal` attribute located in a recipe
9. An `override` attribute located in an attribute file
10. An `override` attribute located in a recipe
11. An `override` attribute located in a role
12. An `override` attribute located in an environment
13. A `force_override` attribute located in an attribute file
14. A `force_override` attribute located in a recipe
15. An `automatic` attribute identified by Ohai at the start of the chef-client run

--

## Files

> These are static files that can be uploaded to nodes. Files can be configuration files, scripts, website
  files – anything that does not been to have different values on different nodes.

--

## Libraries

> A library allows arbitrary Ruby code to be included in a cookbook, either as a way of extending the classes that are
  built-in to the chef-client — `Chef::Recipe`. Because a library is built using Ruby, anything that can be done with
  Ruby can be done in a library file.

--

## Lightweight Resources and Providers

> A LWRP is a part of a cookbook that is used to extend the chef-client in a way that allows custom actions to be
  defined, and then used in recipes in much the same way as any platform resource. In other words: a LWRP is a custom
  resource. A custom resource has two principal components:

> - A custom resource that defines a set of actions and attributes that is located in a cookbook’s `/resources` directory
> - A custom provider that tells the chef-client how to handle each action, what to do if certain conditions are met,
    and so on that is located in a cookbook’s `/providers` directory

--

## Recipes

> The recipes directory contains the "recipes" that define how the service should be configured. Recipes are
  generally small files that configure specific aspects of the larger system. If a cookbook used to install and
  configure a web server, a recipe may enable a module or set up firewall.

--

## Templates

> The templates directory is used to provide more complex configuration management. You can provide entire
  configuration files that contain embedded Ruby commands. The variables that are printed can be defined in other
  files.

---

# Let's Create a Cookbook

--

## Generate new Cookbook

```bash
knife cookbook create nginx-config -o site-cookbooks

** Creating cookbook nginx-config in /Users/www/slides/chef/site-cookbooks
** Creating README for cookbook: nginx-config
** Creating CHANGELOG for cookbook: nginx-config
** Creating metadata for cookbook: nginx-config
```
<!-- .element: class="command-line" data-output="2-6" -->

--

## Dependencies

Need to add a dependency on the nginx cookbook:

Add this line to the end of the `metadata.rb`

```ruby
depends 'nginx'
```

--

## Add "nginx" cookbook

Berksfile <!-- .element: class="filename" -->

```ruby
source 'https://supermarket.chef.io'

cookbook 'openssh'
cookbook 'sudo'
cookbook 'swap_tuning'
cookbook 'users'
cookbook 'nginx'
```

and run

```bash
berks install
```
<!-- .element: class="command-line" -->

--

## Attributes

sites-cookbook/nginx-config/attributes/default.rb <!-- .element: class="filename" -->

```ruby
default['project']['domain'] = 'example.com'
default['project']['root'] = '/home/deployer/site'
```

--

## Recipe

sites-cookbook/nginx-config/recipes/default.rb <!-- .element: class="filename" -->

```ruby
include_recipe 'nginx::source'

template "#{node['nginx']['dir']}/sites-available/site" do
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    ip: node[:ipaddress],
    domain: node['project']['domain'],
    project_root: node['project']['root']
  )
  notifies :restart, 'service[nginx]', :delayed
end

nginx_site 'site' do
  enable true
end
```

--

## Template

sites-cookbook/nginx-config/templates/default/site.erb <!-- .element: class="filename" -->

```
upstream puma {
  server unix://<%= @project_root %>/shared/tmp/sockets/puma.sock;
}

server {
  listen 80;

  server_name <%= @domain %> <%= @ip %>;

  client_max_body_size 64M;

  root <%= @project_root %>/current/public;

  index index.html;

  resolver 8.8.8.8 8.8.4.4 208.67.222.222 valid=300s;
  resolver_timeout 10s;

  error_page 500 502 503 504 /500.html;

  location ^~ /assets/ {
    gzip_static on;
    expires max;
    add_header Last-Modified: $date_gmt;
    add_header Cache-Control: max-age;
    add_header Expires: max-age;
    access_log off;
  }

  try_files $uri/index.html $uri @puma;

  location @puma {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_redirect off;
    proxy_pass http://puma;
  }
}
```

--

## Run List

Add nginx-config recipe to the run-list:

nodes/XXX.XXX.XXX.XXX.json <!-- .element: class="filename" -->

```json
{
  "environment": "production",
  "users": ["deployer"],
  "authorization": {
    "sudo": {
      "groups": ["deployer", "sysadmin", "www-data"],
      "users": ["deployer"],
      "passwordless": "false"
    }
  },
  "swap_tuning": {
    "minimum_size": 4096
  },
  "run_list": [
    "recipe[swap_tuning]",
    "recipe[sudo]",
    "recipe[users::sysadmins]",
    "recipe[nginx-config]"
  ],
  "automatic": {
    "ipaddress": "XXX.XXX.XXX.XXX"
  }
}
```

---

# Time to cook!

--

## Prepare the remote host

Run these commands to prepare and cook remote host

```bash
knife solo prepare root@XXX.XXX.XXX.XXX
knife solo cook root@XXX.XXX.XXX.XXX
```
<!-- .element: class="command-line" -->

Or just run this one command. This is an alias for two previous ones.

```bash
knife solo bootstrap root@XXX.XXX.XXX.XXX
```
<!-- .element: class="command-line" -->

And clean uploaded kitchen

```bash
knife solo clean root@XXX.XXX.XXX.XXX
```
<!-- .element: class="command-line" -->

--

## What do these commands?

> - `knife solo prepare` installs Chef on a given host. It's structured to auto-detect the target OS and change the installation process accordingly.
> - `knife solo cook` uploads the current kitchen (Chef repo) to the target host and runs chef-solo on that host.
> - `knife solo bootstrap` combines the two previous ones (prepare and cook).
> - `knife solo clean` removes the uploaded kitchen from the target host.

---

## Examples

[Simple Chef Configuration](https://github.com/timlar/chef-example-for-rubygarage-course)

---

## Tip: How to generate password for PostgreSQL

This command returns an encrypted password

```bash
md5 -qs '1q2w3e4r5t6y'

ede6b50e7b5826fe48fc1f0fe772c48f
```
<!-- .element: class="command-line" data-output="2-3" -->

And in the end the password will be like this `md5ede6b50e7b5826fe48fc1f0fe772c48f`

> Don't forget about 'md5' in the beginning of the line.

---

## Documentations

- [Supermarket](https://matschaffer.github.io/knife-solo/)
- [Berkshelf](https://docs.chef.io/berkshelf.html)
- [Knife Solo](https://matschaffer.github.io/knife-solo/)
- [Knife Solo Data Bag](https://github.com/thbishop/knife-solo_data_bag)
- [Chef Overview](https://docs.chef.io/chef_overview.html)
- [Chef Solo](https://docs.chef.io/chef_solo.html)
- [Data Bags](https://docs.chef.io/data_bags.html)
- [Cookbooks](https://docs.chef.io/cookbooks.html)
- [FoodCritic](http://www.foodcritic.io)

---

# The End
