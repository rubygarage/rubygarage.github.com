require 'rack/test'
require 'lib/img_postprocessor'

class PresentationStatic

  class TestApp
    attr_reader :app

    include Rack::Test::Methods

    def initialize(app)
      @app = app
    end
  end

  # Returns {Array} of paths we want to generate
  # static pages for.
  attr_reader :paths

  def initialize(app, options={})
    @sinatra  = app
    @assets   = app.sprockets

    if path = options[:select_path]
      @paths = paths.select { |p| p == path }
    end
  end

  def build!
    paths.each {|p| build_path(p)}
    self
  end

  private

  def logger
    @sinatra.sprockets.logger
  end

  def paths
    @paths ||= @sinatra.each_route.select {|r| r.verb == 'GET'}.map(&:path)
  end

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
      f.write(get_path(path, 'html'))
    end
  end

  def build_assets(path)
    @app = @assets
    full_assets_path = full_assets_path(path)

    FileUtils.mkdir_p(full_assets_path)
    %w(css js).each do |type|
      full_file_path = File.join(full_assets_path, "#{path}.#{type}")
      File.open(full_file_path, 'w+') do |f|
        f.write(get_path("#{path}.#{type}", type))
      end
    end
  end

  def get_path(path, type=nil)
    contents = TestApp.new(@app).get(path).tap do |resp|
      handle_error_non_200!(path) unless resp.status == 200
    end.body

    if type == 'html' && contents =~ /<img/
      logger.debug "#{path} has <img> tags"
      FileUtils.mkdir_p(full_assets_path(path))

      p = ImgPostprocessor.new(contents, logger: logger)
      p.assets_prefix = File.join(File.basename(@sinatra.public_folder), path, @sinatra.assets_prefix)
      p.base_path     = File.dirname(@sinatra.public_folder)

      return p.process!
    end

    if type == 'css'
      # Remove comments with absolute file paths and line numbers
      return contents.gsub(/\/\*.+\*\/\n/,'')
    end
    contents
  end

  def full_assets_path(path)
    File.join(@sinatra.public_folder, path, @sinatra.assets_prefix)
  end

  def env
    ENV['RACK_ENV']
  end

  def handle_error_non_200!(path)
    puts("failed: GET #{path} returned non-200 status code...")
  end
end
