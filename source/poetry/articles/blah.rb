require 'fileutils'

Dir.glob('*.liquid').each do |path|
  basename = File.basename(path, '.markdown.liquid')
  basename.gsub!('.html', '')
  FileUtils.mkdir(basename) rescue nil
  FileUtils.mv(path, File.join(basename, 'index.markdown.liquid'))
end
