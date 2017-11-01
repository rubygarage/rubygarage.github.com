---
layout: slide
title:  Rake
---

# Rake

---

# The Build Tools

If you've ever tried to install software from source in the Linux or Unix system, there is a high
probability that you have already had contact with make . Installation process usually looks the
same. First you change current directory to that containing uncompressed source code, then you type
in following commands:

```bash
$ ./configure
$ make
$ make install
```

Second and third lines are simply make program invocations. When launched, make first looks for the
Makefile . The latter contains information about source files and dependencies between them. make
sorts the dependencies topologically and tries to resolve them in proper order. So it goes like
this: first, software developer specifies dependencies and then the build tool is responsible for
handling them.  Build tools can be used not only for source code compilation, but that was infact
the task they were created for. In general, build tools are being used to automate tiresome and
repeating tasks.

---

# Rake

`Rake` is a software task management tool. It allows you to specify tasks and describe dependencies
as well as to group tasks in a namespace.  It is similar to `Make`, but it has a number of
differences. The tool is written in the Ruby, and the `Rakefiles` (equivalent of Makefiles in Make)
use Ruby syntax. You don't have to learn new complicated build tool syntax.

--

## Installation

```bash
$ gem install rake
```

--

## First Rake Task

Rake tasks should always be located in file named `rakefile`, `Rakefile`, `rakefile.rb` or `Rakefile.rb`. First
two forms are most commonly used.
Rakefile

```ruby
task :default do
  puts 'Hello World!'
end
```

```bash
$ rake
Hello World!
```

What actually happened? When given Rakefile, Rake is looking for tasks which are simply task method
invocations. There may be many tasks located in one Rakefile. When running Rake from the command
line, you can pass name of the task that you want to be executed. If there is no task given, Rake is
looking for the default task. That is why our Rake invocation did the job without passing any extra
parameters.

---

# Tasks example

Let’s say I wanted to get ready in the morning. My process would be something like this:

1. Turn off alarm clock
2. Groom myself
3. Make coffee
4. Walk dog

--

In rake I might express my morning as follows:

Rakefile <!-- .element: class="filename" -->

```ruby
task :turn_off_alarm do
  puts 'Turned off alarm. Would have liked 5 more minutes, though.'
end

task :groom_myself do
  puts 'Brushed teeth.'
  puts 'Showered.'
  puts 'Shaved.'
end

task :make_coffee do
  puts 'Made a cup of coffee. Shakes are gone.'
end

task :walk_dog do
  puts 'Dog walked.'
end
```

--

```bash
$ rake turn_off_alarm
Turned off alarm. Would have liked 5 more minutes, though.
```

```bash
$ rake groom_myself
Brushed teeth.
Showered.
Shaved.
```

```bash
$ rake make_coffee
Made a cup of coffee. Shakes are gone.
```

```bash
$ rake walk_dog
Dog walked.
```

---

# Expressing dependencies

Rakefile <!-- .element: class="filename" -->

```ruby
# ...
task ready_for_the_day: %i[turn_off_alarm groom_myself make_coffee walk_dog] do
  puts 'Ready for the day!'
end
```

```bash
$ rake ready_for_the_day
Turned off alarm. Would have liked 5 more minutes, though.
Brushed teeth.
Showered.
Shaved.
Made a cup of coffee. Shakes are gone.
Dog walked.
Ready for the day!
```

By running the `ready_for_the_day` task it notices that the `turn_off_alarm`, `groom_myself`,
`make_coffee`, and `walk_dog` tasks are all prerequisites of the `ready_for_the_day` task. Then it
runs them all in the appropriate order.

--

# Expressing dependencies

Dependencies can be specified not only when defining the task, but also later, depending on the run
time conditions.

Rakefile <!-- .element: class="filename" -->

```ruby
# ...
task :ready_for_the_day do
  puts 'Ready for the day!'
end

task ready_for_the_day: %i[turn_off_alarm groom_myself make_coffee walk_dog]
```

Effect will be the same.

---

# Namespaces

Rake supports the concept of namespaces which essentially lets you group together similar tasks
inside of one namespace. You’d then specify the namespace when you call a task inside it. It keeps
things tidy while still being quite effective.

Rakefile <!-- .element: class="filename" -->

```ruby
namespace :morning do
  task :turn_of_alarm
  # ...
end
```

```bash
$ rake morning:ready_for_the_day
...
```

---

# The Default Task

Rake has the concept of a default task. This is essentially the task that will be run if you type rake without any
arguments. If we wanted our default task to be turning off the alarm from the example above, we'd do this:

Rakefile <!-- .element: class="filename" -->

```ruby
task default: 'morning:turn_off_alarm'
# ...
```

```bash
$ rake
Turned off alarm. Would have liked 5 more minutes, though.
```

---

# Describing tasks

You can use the desc method to describe your tasks. This is done on the line right above the task definition. It’s also
what gives you that nice output when you run `rake -T` to get a list of tasks. Tasks are displayed in alphabetical
order.

Rakefile <!-- .element: class="filename" -->

```ruby
desc 'Make coffee'
  task :make_coffee do
    puts 'Made a cup of coffee. Shakes are gone.'
  end
end
```

```bash
$ rake -T
rake morning:make_coffee # Make coffee
```

---

# Redefining tasks

Let’s say you want to add on to an existing task. Perhaps you have another item in your grooming
routine like styling your hair. You could write another task and slip it in as a dependency for
`groom_myself` but you could also redefine `groom_myself`.

Rakefile <!-- .element: class="filename" -->

```ruby
namespace :morning do
  task :groom_myself do
    puts 'Brushed teeth.'
    puts 'Showered.'
    puts 'Shaved.'
  end
end

namespace :morning do
  task :groom_myself do
    puts 'Styled hair.'
  end
end
```

```bash
$ rake morning:groom_myself
Brushed teeth.
Showered.
Shaved.
Styled hair.
```

---

# Invoking tasks

You may at some point want to invoke a task from inside another task. Let’s say, for example, you
wanted to make coffee in the afternoon, too. If you need an extra upper after lunch you could do
that the following way:

Rakefile <!-- .element: class="filename" -->

```ruby
namespace :afternoon do
  task :make_coffee do
    Rake::Task['morning:make_coffee'].invoke

    puts 'Ready for the rest of the day!'
  end
end
```

```bash
$ rake afternoon:make_coffee
Made a cup of coffee. Shakes are gone.
Ready for the rest of the day!
```

---

# Invoking and executing

--

## Invoke

```ruby
Rake::Task['morning:make_coffee'].invoke
```

This one executes the dependencies, but it only executes the task if it has not already been invoked.

--

## Reenable

```ruby
Rake::Task['morning:make_coffee'].reenable
Rake::Task['morning:make_coffee'].invoke
```

This first resets the task's `already_invoked` state, allowing the task to then be executed again,
dependencies and all.

--

## Execute

```ruby
Rake::Task['morning:make_coffee'].execute
```

This always executes the task, but it doesn't execute its dependencies.

---

# Passing parameters to tasks

--

## Using a named variable

Rakefile <!-- .element: class="filename" -->

```ruby
namespace :morning do
  desc 'Make coffee'
  task :make_coffee do
    cups = ENV['cups']

    puts "Made #{cups} cups of coffee. Shakes are gone."
  end
end
```

```bash
$ rake morning:make_coffee cups=2
Made 2 cups of coffee. Shakes are gone.
```

--

## Using arguments

Rakefile <!-- .element: class="filename" -->

```ruby
namespace :morning do
  desc 'Make coffee'
  task :make_coffee, :cups do |t, args|
    cups = args.cups

    puts "Made #{cups} cups of coffee. Shakes are gone."
  end
end
```

```bash
$ rake morning:make_coffee[2]
Made 2 cups of coffee. Shakes are gone.
```

--

## Custom black magic

Rakefile <!-- .element: class="filename" -->

```ruby
namespace :morning do
  desc 'Make coffee'
  task :make_coffee do
    cups = ARGV.last

    puts "Made #{cups} cups of coffee. Shakes are gone."

    task cups.to_sym do ; end
  end
end
```

```bash
$ rake morning:make_coffee 2
Made 2 cups of coffee. Shakes are gone.
```

--

A few things are happening here that are worth an explanation:

1. We are using the ARGV collection of command line arguments to grab the value for our argument.
Standard Ruby stuff.  Beware though, that this collection will contain all the arguments for
Rake, not our task. That’s why we grab the last element in the collection because the first element
is the name of our rake task.

2. We have to define a new rake task on the fly with the same name as the value of our argument. If
we don’t do this, rake will attempt to invoke a task for each command line argument.

---

# How to test it

--

## Write a test

Some notable aspects of testing Rake tasks:

- Rake has to be required
- The Rake file under test has to be manually loaded

--

spec/morning_rake_spec.rb <!-- .element: class="filename" -->

```ruby
require 'rake'

describe 'morning namespace rake task' do
  before :all do
    load File.expand_path('../../Rakefile', __FILE__)
    Rake::Task.define_task(:environment)
  end

  describe 'morning:make_coffee' do
    before do
      Rake::Task['morning:make_coffee'].reenable
    end

    context 'one cup' do
      it 'should make cup of coffee' do
        Coffee.should_receive(:new).with(1)
        Rake::Task['morning:make_coffee'].invoke
      end

      it "should say 'Made 1 cups of coffee'" do
        $stdout.should_receive(:puts).with('Made 1 cups of coffee. Shakes are gone.')
        Rake::Task['morning:make_coffee'].invoke
      end
    end

    context 'two cups' do
      it 'should make two cups of coffee' do
        Coffee.should_receive(:new).with(2)
        Rake::Task['morning:make_coffee'].invoke(2)
      end

      it "should say 'Made 2 cups of coffee'" do
        $stdout.should_receive(:puts).with('Made 2 cups of coffee. Shakes are gone.')
        Rake::Task['morning:make_coffee'].invoke(2)
      end
    end
  end
end
```

--

## Implementation

Rakefile <!-- .element: class="filename" -->

```ruby
class Coffee
  def initialize cups = 1
  end
end

namespace :morning do
  desc "Make coffee"
  task :make_coffee, :cups do |t, args|
    cups = args.cups || 1
    coffee = Coffee.new cups

    puts "Made #{cups} cups of coffee. Shakes are gone."
  end
end
```

```bash
$ rspec spec/morning_rake_spec.rb

Made 1 cups of coffee. Shakes are gone.
..Made 2 cups of coffee. Shakes are gone.
..

Finished in 0.97735 seconds
4 examples, 0 failures
```

---

# The End
