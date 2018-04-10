---
layout: slide
title:  Sidekiq
---

# Sidekiq

Background jobs processing.

---

## Sidekiq

* Stores jobs in [Redis](https://redis.io/) which is inherently faster over relational databases.
* Makes use of threads to process multiple jobs at same time in the same process.
* Provides Web UI to monitor the job processing.

---

## Using

Add sidekiq to your Gemfile:

```ruby
gem 'sidekiq'
```

Add a worker in app/workers to process jobs asynchronously:

```bash
rails g sidekiq:worker HelloWorld
```

```ruby
class HelloWorld
  include Sidekiq::Worker

  def perform
    puts 'Hello world'
  end
end
```

--

## Execution

Run a job to be processed asynchronously:

```ruby
HelloWorld.perform_async
```

Create a job to be processed in the future:

```ruby
HelloWorld.perform_in(3.hours)
HelloWorld.perform_at(3.hours.from_now)
```

--

Sidekiq persists the arguments to `perform` to Redis. Don't save state to Sidekiq, save simple identifiers.

```ruby
quote = Quote.find(quote_id)
SomeWorker.perform_async(quote)
```

User identifiers instead of objects as an arguments.

```ruby
SomeWorker.perform_async(quote_id)
```

---

## Sidekiq Server

Each Sidekiq server process pulls jobs from the queue in Redis and processes them. Like your web processes, Sidekiq boots Rails so your jobs and workers have the full Rails API, including Active Record, available for use.

```bash
bundle exec sidekiq -d -C config/sidekiq.yml
```

---

## Configuring

Sidekiq's scheduler by default checks for jobs every 15 seconds.

```ruby
Sidekiq.configure_server do |config|
  config.average_scheduled_poll_interval = 15
end
```

--

By default, Sidekiq tries to connect to Redis at `localhost:6379/0`. This typically works great during development but needs tuning in production.

```ruby
Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis.example.com:7372/1' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis.example.com:7372/2' }
end
```

--

The Sidekiq configuration file is a YAML file that Sidekiq server uses to configure itself, by default located at `config/sidekiq.yml`.

config/sidekiq.yml <!-- .element: class="filename" -->

```yml
:pidfile: ./tmp/pids/sidekiq.pid
:logfile: ./log/sidekiq.log
:concurrency: 10
```

---

# Web UI

![](/assets/images/sidekiq/dashboard.jpg) <!-- .element: style="width:1024px" -->

--

Add the following to your `config/routes.rb`:

config/routes.rb <!-- .element: class="filename" -->

```ruby
require 'sidekiq/web'
mount Sidekiq::Web => '/sidekiq'
```

---

## Testing

[https://github.com/philostler/rspec-sidekiq](https://github.com/philostler/rspec-sidekiq)

--

Gemfile <!-- .element: class="filename" -->

```ruby
group :test do
  gem 'rspec-sidekiq'
end
```

spec_helper.rb <!-- .element: class="filename" -->

```ruby
require 'sidekiq/testing'

RSpec::Sidekiq.configure do |config|
  config.clear_all_enqueued_jobs = true
  config.enable_terminal_colours = true
  config.warn_when_jobs_not_processed_by_sidekiq = true
end
```

--

app/workers/some_worker.rb <!-- .element: class="filename" -->

```ruby
class SomeWorker
  include Sidekiq::Worker

  def perform
    SomeService.call
  end
end
```

spec/workers/some_worker_spec.rb <!-- .element: class="filename" -->

```ruby
describe SomeWorker, type: :worker do
  it 'should call SomeService' do
    expect(SomeService).to receive(:call)

    subject.perform(type, network.id, charge_id)
  end
end
```

---

# Queues

By default, sidekiq uses a single queue called `default` in Redis. 

--

## Add more queues

In the configuration file:

```yml
# ...
:queues:
  - [critical, 2]
  - default
```

Each queue can be configured with an optional weight. A queue with a weight of 2 will be checked twice as often as a queue with a weight of 1.

--

If you want queues always processed in a specific order, just declare them in order without weights:

```yml
# ...
:queues:
  - critical
  - default
  - low
```

--

You can specify a queue to use for a given worker by declaring it:

```ruby
class ImportantWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'critical'

  def perform(*important_args)
    puts "Doing critical work"
  end
end
```

---

# Scheduling

--

## sidekiq-scheduler

`sidekiq-scheduler` is an extension to Sidekiq that pushes jobs in a scheduled way, mimicking cron utility.

[https://github.com/moove-it/sidekiq-scheduler](https://github.com/moove-it/sidekiq-scheduler)

--

## Using

Add sidekiq-scheduler to your Gemfile:

```ruby
gem 'sidekiq-scheduler'
```

config/initializers/sidekiq_scheduler.rb <!-- .element: class="filename" -->

```ruby
require 'sidekiq'
require 'sidekiq/scheduler'

Sidekiq.configure_server do |config|
  config.on(:startup) do
    Sidekiq.schedule = YAML.load_file(File.expand_path('../../sidekiq_scheduler.yml', __FILE__))
    Sidekiq::Scheduler.enabled = true
    Sidekiq::Scheduler.reload_schedule!
  end
end
```

config/sidekiq_scheduler.yml <!-- .element: class="filename" -->

```yml
hello_world_worker:
  every: '24h'
  class: HelloWordWorker
```

--

## Let's make something useful


Simple PostgreSQL backups.

Install [pg_drive_backup](https://github.com/kirillshevch/pg_drive_backup)

--

## Service

app/services/backup.rb <!-- .element: class="filename" -->

```ruby
class BackupService
  def self.call
    PgDriveBackup::Run.call
  end
end
```

--

## Worker

app/workers/backup_worker.rb <!-- .element: class="filename" -->

```ruby
require 'sidekiq-scheduler'

class BackupWorker
  include Sidekiq::Worker

  def perform
    Backup.call
  end
end
```

--

## Config

config/sidekiq_scheduler.yml <!-- .element: class="filename" -->

```yml
backup_worker:
  every: '12h'
  class: BackupWorker
```

--

## Dashboard

![](/assets/images/sidekiq/scheduler.jpg) <!-- .element: style="width:1280px" -->

---

# The End
