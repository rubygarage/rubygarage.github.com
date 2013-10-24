require 'lib/page_processable'

class ImgPostprocessor < PageProcessable

  attr_accessor :assets_prefix, :base_path

  # List of supported tags and
  # their attributes to put URL to
  def tags
    {'img' => 'src'}
  end

private

  def process_element(el)
    attr = tags[el.name]

    src_file_name = el.attributes[attr].value.gsub('assets', '').gsub('./','')
    dst_file_name = File.basename(src_file_name)
    logger.debug "Copy: #{file_source(src_file_name)} -> #{file_dest(dst_file_name)}"
    FileUtils.cp(file_source(src_file_name), file_dest(dst_file_name))

    el.attributes[attr].value = File.join('/', assets_prefix, dst_file_name)
  end

  def build_selector(tag, attr)
    %{,#{tag}[#{attr}!=""]}
  end

  def file_source(file_name)
    File.join(base_path, 'assets', 'images', file_name)
  end

  def file_dest(file_name)
    File.join(base_path, assets_prefix ,file_name)
  end
end
