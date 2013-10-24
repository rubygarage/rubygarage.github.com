##
# Class: PageProcessable
#
# Selects elements from HTML page contents to
# post-process them
#
# The class is abstract.
class PageProcessable
  # {String} page contents
  attr_accessor :page

  attr_accessor :logger

  # List of supported tags and
  # their attributes to put URL to.
  #
  # Returns {Hash} with tag names as keys and attributes as values
  def tags
    raise NotImplementedError
  end

  # Processes page.content by adding URLs to
  # required places.
  #
  # Returns {String} with HTML content.
  def process!
    required_tags.each do |el|
      process_element(el)
    end
    document.to_xhtml(indent: 3, indent_text: ' ')
  end

private

  # Builds selector for each tag kind.
  # In the result it can look like 'a[href=""]'
  #
  # Params:
  #   - tag   {String} name of tag
  #   - attr  {String} attribute of the tag to add to selector
  #
  # Returns {String} with CSS selector, reasonable for Nokogiri
  def build_selector(tag, attr)
    raise NotImplementedError
  end

  # Processes each element, found by built tags.
  #
  # Params:
  #   - el {Nokogiri::XML::Node} as an element representation
  def process_element(el)
    raise NotImplementedError
  end

  # Initializes an instance of PageProcessable
  #
  # Params:
  #   - page {String} to take 'content' from
  def initialize(page, opts={})
    self.page = page
    self.logger = opts[:logger] || Logger.new(STDOUT)
  end

  def document
    @_document ||= Nokogiri::HTML.parse(page)
  end

  def required_tags
    document.css(selector)
  end

  # Returns {String} with CSS selector (with JQuery flavour),
  # required to get needed elements.
  def selector
    return @_selector if @_selector
    @_selector = ''
    tags.each do |tag, attr|
      @_selector << build_selector(tag, attr)
    end
    @_selector = @_selector[1..-1] # remove leading ','
  end
end

