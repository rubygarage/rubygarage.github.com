require './app'
require './lib/static'

namespace :static do
  desc 'genarate presentations'
  task :genarate do
    builder = PresentationStatic.new(App)
    builder.build!
    puts 'Static presentations ready to use'
  end
end