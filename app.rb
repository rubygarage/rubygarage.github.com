require 'bundler'
Bundler.require

require 'sinatra/advanced_routes'

class App < Sinatra::Base
  register Sinatra::Partial
  register Sinatra::AdvancedRoutes

  set :root, File.expand_path(File.dirname(__FILE__))
  set :sprockets, Sprockets::Environment.new(root) { |env| env.logger = Logger.new(STDOUT) }
  set :assets_prefix, '/assets'
  set :digest_assets, false
  set :partial_template_engine, :erb

  configure do
    %w(stylesheets javascripts images).each do |type|
      sprockets.append_path(File.join(root, 'assets', type))
      sprockets.append_path(File.join(root, 'vendor', 'assets', type))
      sprockets.append_path(File.join(Gem.loaded_specs['bootstrap-sass'].full_gem_path, 'vendor', 'assets', type))
    end

    Sprockets::Helpers.configure do |config|
      config.environment = sprockets
      config.prefix      = assets_prefix
      config.digest      = digest_assets
      config.public_path = public_folder
    end
    Sprockets::Sass.add_sass_functions = false
  end

  get "/gems" do
    erb :gems
  end

  get "/metaprogramming" do
    erb :metaprogramming
  end

  get "/rspec" do
    erb :rspec
  end

  get "/rake" do
    erb :rake
  end

  get "/rubybasics" do
    erb :rubybasics
  end

  get "/rack" do
    erb :rack
  end

  get "/oop" do
    erb :oop
  end

  get "/rails" do
    erb :rails
  end

  get "/models" do
    erb :models
  end

  get "/routes" do
    erb :routes
  end

  get "/controllers" do
    erb :controllers
  end

  helpers do
    include Sprockets::Helpers
  end
end
