$: << '.'

require 'app'
require 'lib/static'

namespace :static do
  desc 'generate presentations'
  task :generate do
    opts = {}
    if path = ENV['path']
      opts[:select_path] = path
    end

    builder = PresentationStatic.new(App, opts)
    builder.build!
    puts 'Static presentations ready to use'
  end
end