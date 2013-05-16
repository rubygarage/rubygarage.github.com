require './app'
require './lib/static'

namespace :static do
  desc 'generate presentations'
  task :generate do
    builder = PresentationStatic.new(App)
    builder.build!
    puts 'Static presentations ready to use'
  end
end