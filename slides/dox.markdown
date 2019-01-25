---
layout: slide
title:  Dox
---

# Dox

## Automated API documentation tool for Rspec.

Dox generates API documentation from Rspec controller/request specs in a Rails application. This brings advantages like:

<br/>

- made documentation maintenance less painful and time consuming
- formats the tests output in the API Blueprint format
- keeping documentation up to date
- clean application code

<br/>

After buliding task your documentation will be available in your application as static html-file.

--

# Getting started

Add this line to your application's Gemfile:

```ruby
group :test do
  gem 'dox', require: false
end
```

And then execute:

```bash
bundle install
```

Require Dox and configure rspec in the rails_helper.rb:

```ruby
# spec/rails_helper.rb

require 'dox'

RSpec.configure do |config|
  config.after(:each, :dox) do |example|
    example.metadata[:request] = request
    example.metadata[:response] = response
  end
end
```

--

# Dox configuration

Create folder with markdown descriptions:

```bash
mkdir -p spec/docs/v1/descriptions
```

Create markdown file that will be included at the top of the documentation. It should contain title and some basic info about the api.

```bash
touch spec/docs/v1/descriptions/header.md
```

Config Dox in the rails_helper.rb:

```ruby
# spec/rails_helper.rb

Dir[Rails.root.join('spec/docs/**/*.rb')].each { |file| require file }

Dox.configure do |config|
  config.header_file_path = Rails.root.join('spec/docs/v1/descriptions/header.md')
  config.desc_folder_path = Rails.root.join('spec/docs/v1/descriptions')
  config.headers_whitelist = ['Accept', 'X-Auth-Token']
end
```

header_file_path, desc_folder_path are mandatory options. Requests and responses will by default list only Content-Type header. To list other http headers, you must whitelist them. You can config it with option ```headers_whitelist```

--

# Create descriptor

Define a descriptor module for a resource using Dox DSL:

```ruby
# spec/docs/v1/projects.rb

module Docs
  module V1
    module Projects
      extend Dox::DSL::Syntax

      # define common resource data for each action
      document :api do
        resource 'Projects' do
          endpoint '/projects'
          group 'Projects'
        end
      end

      # define data for specific action
      document :index do
        action 'Get projects'
      end
    end
  end
end
```

--

# Tag specs to documentate

Include the descriptor modules in a request and tag the specs you want to document with dox:

```ruby
# spec/requests/v1/projects_spec.rb

RSpec.describe 'V1::Projects API', type: :request do
  include Docs::V1::Projects::Api

  describe 'GET /api/projects' do
    include Docs::V1::Projects::Index

    before { get '/api/projects', headers: valid_headers }

    it 'gets projects', :dox do
      expect(response).to have_http_status(200)
    end
  end
```

--

# Config environment

Documentation will be generated in 2 steps:

- generating API Blueprint markdown
- rendering HTML from MD

In this case we will render with Aglio, so let's install it. Checkout your current NodeJS version. Skip next step if you version of NodeJS >= 10.x

```bash
nodejs -v
```

Let’s add the PPA to your system and install Nodejs on Ubuntu:

```bash
sudo apt-get install curl python-software-properties
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install nodejs
```

After installing node.js verify and check the installed version:

```bash
nodejs -v
npm -v
```

--

# Installing Aglio

What is Aglio? It's an API Blueprint renderer that supports multiple themes and outputs static HTML that can be served by any web host. API Blueprint is a Markdown-based document format that lets you write API descriptions and documentation in a simple and straightforward way. Currently supported is API Blueprint format 1A.

It comes with a few predefined themes and layouts with support for generating a custom color theme or a Jade template. Checkout <a href='https://infinum.github.io/dox-demo/aglio' target='_blank'>demo app API documentation</a> rendered with Aglio.

You may need to use sudo to install globally:

```bash
sudo npm install -g aglio
```

If install crashes you can try to use it with ```unsafe-perm``` key:

```bash
sudo npm install --unsafe-perm --verbose -g aglio
```

--

# Create rake task

```bash
mkdir public/docs
touch lib/tasks/generate_api_documentation.rake
```

```ruby
# lib/tasks/generate_api_documentation.rake

namespace :api do
  namespace :v1 do
    desc 'Generate API v1 documentation'

    md_file, html_file = 'spec/docs/v1/docs.md', 'public/docs/v1.html'

    task :md do
      RSpec::Core::RakeTask.new(:api_spec) do |t|
        t.rspec_opts = "-f Dox::Formatter --order defined --tag dox --out #{md_file}"
      end

      Rake::Task['api_spec'].invoke
    end

    task :html do
      system("aglio -i #{md_file} -o #{html_file}")
    end

    task docs: ['api:v1:md', 'api:v1:html']
  end
end
```

--

# Generate documentation

Just run rake task for build your documentation:

```bash
rails api:v1:docs
```

And your documentation will be render to:

```bash
public/docs/v1.html
```
<br/>

Also you can include it in your CI process. To keep the documentation always up to date, it's best to integrate generating the documentation and publishing it to your CI setup.

--

# Conclusion

Dox is simple to use and it extracts enough data from the tests to give you a minimal documentation, yet it provides options to override some attributes and add custom markdown descriptions where needed. It should take you no time to plug it in your Rails/RSpec API app and start enjoying the extra time.

--
