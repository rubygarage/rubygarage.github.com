---
layout: slide
title:  ActiveMQ
---

# ActiveMQ

Open source multi-protocol Messaging Broker.

--

# Advantages

* Supports many [Cross Language Clients and Protocols](http://activemq.apache.org/cross-language-clients)
* High availability using shared storage (master/slave)
* KahaDB & JDBC options for persistence

---

# Installing

ActiveMQ requires Java 7 to run and to build.

## Brew (on MacOS)

```bash
brew install apache-activemq
activemq start
```
<!-- .element: class="command-line" -->

## Unix Binary Installation

Download latest version [here](http://activemq.apache.org/components/classic/download/)

And follow up the [documentation](http://activemq.apache.org/version-5-getting-started.html)

--

## Docker

[https://hub.docker.com/r/rmohr/activemq/](https://hub.docker.com/r/rmohr/activemq/)

```bash
docker pull rmohr/activemq
docker run -p 61616:61616 -p 8161:8161 rmohr/activemq
```

--

# CLI commands

`activemq start` - Creates and starts a broker using a configuration file.

`activemq stop` - Stops a running broker

`activemq restart` - Restarts a running broker

--

# Start ActiveMQ

```bash
activemq start

INFO: Loading '/usr/local/Cellar/activemq/5.15.9/libexec//bin/env'
INFO: Using java '/Library/Java/JavaVirtualMachines/jdk1.8.0_102.jdk/Contents/Home/bin/java'
INFO: Starting - inspect logfiles specified in logging.properties and log4j.properties to get details
INFO: pidfile created : '/usr/local/Cellar/activemq/5.15.9/libexec//data/activemq.pid' (pid '61388')
```
<!-- .element: class="command-line" -->

--

# Monitoring ActiveMQ

You can monitor ActiveMQ using the Web Console by pointing your browser at

```
http://localhost:8161/admin
```

Default credentials
```
login: admin
pass: admin
```

--

![](/assets/images/activemq/activemq-admin.jpg) <!-- .element: style="width:1280px" -->


---

# Messaging Patterns

--

# Queue

Queues are the most obvious messaging pattern implemented by ActiveMQ. They provide a direct channel between a producer and a consumer. The producer creates messages, while the consumer reads one after another. After a message was read, it’s gone. If multiple consumers are registered for a queue, only one of them will get the message.

![](/assets/images/activemq/queue.png) <!-- .element: style="width:1280px" -->

--

# Topic

Topics implement an one-to-many channel between a producer and multiple consumers. Unlike an queue, every consumer will receive a message send by the producer.

![](/assets/images/activemq/topics.png) <!-- .element: style="width:1280px" -->

--

# Virtual Topics

Virtual topics combine both approaches. While the producer sends messages to a topic, consumers will receive a copy of the message on their own dedicated queue.

![](/assets/images/activemq/virtual-topics.png) <!-- .element: style="width:1280px" -->

---

# Protocols

### AMQP, AUTO, MQTT, OpenWire, REST, RSS and Atom, Stomp, WSIF, WS Notification, XMPP
[https://activemq.apache.org/protocols.html](https://activemq.apache.org/protocols.html)

--

# REST

ActiveMQ implements a RESTful API to messaging which allows any web capable device to publish messages using a regular HTTP POST or GET.

--

# Publish to Queue

```sh
curl -u admin:admin -d "body=order_id" http://localhost:8161/api/message/shop?type=queue
```
<!-- .element: class="command-line" -->

--

![](/assets/images/activemq/activemq-queue.jpg) <!-- .element: style="width:1280px" -->

--

# Publish to Topic

```sh
curl -u admin:admin -d "body=order_id" http://localhost:8161/api/message/shop?type=topic
```
<!-- .element: class="command-line" -->

--

![](/assets/images/activemq/activemq-topic.jpg) <!-- .element: style="width:1280px" -->

---

# Integration with Ruby

--

# STOMP

The Simple Text Oriented Messaging Protocol

STOMP provides an interoperable wire format so that STOMP clients can communicate with any STOMP message broker to provide easy and widespread messaging interoperability among many languages, platforms and brokers.

--

## STOMP

A ruby gem for sending and receiving messages from a Stomp protocol compliant message queue. Includes: failover logic, ssl support.

Gemfile <!-- .element: class="filename" -->

```ruby
gem 'stomp'
```

```bash
bundle install
```
<!-- .element: class="command-line" -->

--

## Initialize Connection

```ruby
def config_hash
  { 
    hosts: [
      { 
        login: 'admin', 
        passcode: 'admin',
        host: '0.0.0.0',
        port: 61613,
        ssl: false 
      }
    ]
  }
end

client = Stomp::Client.new(config_hash)
```

--

# Send a Message to Queue

```ruby
client = Stomp::Client.new(config_hash)

data = { order_id: 1, command: :paid }

client.publish('/queue/user-notifications', data.to_json)

client.close
```

--

# Receive a Message from Queue

```ruby
client = Stomp::Client.new(config_hash)

Thread.new do
  client.subscribe('/queue/user-notifications') do |msg|
    begin
      msg = JSON.parse(msg.body)

      # message processing...
    rescue StandardError => e
      Raven.capture_exception(e)
    end
  end
end
```

--

![](/assets/images/activemq/queue-used.jpg) <!-- .element: style="width:1280px" -->

---

# Topics

--

# Send a Message to Topic

```ruby
client = Stomp::Client.new(config_hash)

data = { order_id: 1, command: :paid }

client.publish('/topic/user-notifications', data.to_json)

client.close
```

--

# Receive a Message from Topic

```ruby
client = Stomp::Client.new(config_hash)

Thread.new do
  client.subscribe('/topic/user-notifications') do |msg|
    begin
      msg = JSON.parse(msg.body)

      # message processing...
    rescue StandardError => e
      Raven.capture_exception(e)
    end
  end
end
```

---

# Integration with Rails

--

# ActiveMessaging
Attempt to bring the simplicity and elegance of rails development to the world of messaging.

Gemfile <!-- .element: class="filename" -->

```ruby
gem 'activemessaging', github: 'kookster/activemessaging', branch: 'feat/rails5'
gem 'stomp'
```

```bash
bundle install
```

--

# Initializing

```bash
rails g active_messaging:install
```

```bash
  create  app/processors/application_processor.rb
  create  script/poller
    chmod  script/poller
  create  script/threaded_poller
    chmod  script/threaded_poller
  create  lib/poller.rb
  create  config/broker.yml
  gemfile  daemons
```

--

# Generate a listener

```bash
rails g active_messaging:processor RailsQueue
```

```bash
  create  app/processors/rails_queue_processor.rb
  create  config/messaging.rb
  invoke  rspec
  create    spec/functional/rails_queue_processor_spec.rb
```

--

# Destination config

```ruby
ActiveMessaging::Gateway.define do |s|
  s.destination :rails_queue, '/queue/RailsQueue'
end
```

--

# Processor

```ruby
class RailsQueueProcessor < ApplicationProcessor
  subscribes_to :rails_queue

  def on_message(message)
    logger.debug 'RailsQueueProcessor received: ' + message
  end
end
```

--

# Run Application

```bash
script/poller run
```
<!-- .element: class="command-line" -->

---

# Production

--

# AmazonMQ
[https://aws.amazon.com/amazon-mq](https://aws.amazon.com/amazon-mq/)

* Managed message broker service for Apache ActiveMQ
* Uses Apache KahaDB as its data store. Other data stores, such as JDBC and LevelDB, aren't supported.
* Offers low latency messaging, often as low as single digit milliseconds.
* Persistence out of the box

--

# Endpoints

![](/assets/images/activemq/amazon-mq.jpg) <!-- .element: style="width:1280px" -->

--

# FIFO

[http://activemq.apache.org/total-ordering.html](http://activemq.apache.org/total-ordering.html)

```xml
<destinationPolicy>
  <policyMap>
    <policyEntries>
      <policyEntry topic="&gt;">
        <!--
        The constantPendingMessageLimitStrategy is used to prevent
        slow topic consumers to block producers and affect other consumers
        by limiting the number of messages that are retained

        For more information, see: http://activemq.apache.org/slow-consumer-handling.html
        -->
        <dispatchPolicy>
          <strictOrderDispatchPolicy/>
        </dispatchPolicy>
      </policyEntry>
    </policyEntries>
  </policyMap>
</destinationPolicy>
```

---

# The End












