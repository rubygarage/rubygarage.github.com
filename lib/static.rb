require 'rack/test'

class PresentationStatic

  class TestApp
    attr_reader :app

    include Rack::Test::Methods

    def initialize(app)
      @app = app
    end
  end

  def initialize(app)
    @sinatra  = app
    @assets   = app.sprockets
  end

  def build!     
    @sinatra.each_route do |route|     
      next unless route.verb == 'GET'      
      build_path(route.path)
    end
    self
  end

  private

  def build_path(path)                 
    build_file(path)
    build_assets(path)
  end

  def build_file(path)
    @app = @sinatra
    full_path = File.join(@sinatra.public_folder, path)
    FileUtils.mkdir_p(full_path)
    full_file_path = File.join(full_path, 'index.html')
    File.open(full_file_path, 'w+') do |f| 
      f.write(get_path(path).body) 
    end
  end

  def build_assets(path)
    @app = @assets
    full_assets_path = File.join(@sinatra.public_folder, path, @sinatra.assets_prefix)
    FileUtils.mkdir_p(full_assets_path)
    %w(css js).each do |type|
      full_file_path = File.join(full_assets_path, "#{path}.#{type}")
      File.open(full_file_path, 'w+') do |f| 
        f.write(get_path("#{path}.#{type}").body) 
      end
    end
  end

  def get_path(path)
    TestApp.new(@app).get(path).tap do |resp| 
      handle_error_non_200!(path) unless resp.status == 200           
    end
  end

  def env
    ENV['RACK_ENV']
  end  

  def handle_error_non_200!(path)
    puts("failed: GET #{path} returned non-200 status code...")
  end
end