require './app'

map App.assets_prefix do
  run App.sprockets
end

map "/" do
  use Rack::Static,:urls => ["/public"]# :root => 'public'
  run App
end
