task default: [:serve]

task :usage do
  system($PROGRAM_NAME, '-D')
end

desc 'Run on http://localhost:4567'
task :serve do
  sh 'bundle exec middleman'
end

desc 'Upload to gregorymcintyre.com'
task publish: :build do
  sh 'rsync -rvP --delete build/ gregorymcintyre.com:gregorymcintyre.com/'
end

desc 'Regenerate the static site'
task :build do
  sh 'bundle exec middleman build --clean'
end

desc 'Create a new poem. rake poem title="One Two Three"'
task :poem do
  require 'middleman-core/util/uri_templates'
  require 'fileutils'

  include Middleman::Util::UriTemplates

  title = ENV['title']
  if !title || title.empty?
    warn 'Must supply poem title. e.g. rake poem title="One Two Three"'
    exit 1
  end
  date = Time.now.strftime('%Y-%m-%d %H:%M %Z')
  slug = safe_parameterize(title)
  path = "source/poetry/#{slug}/index.html.md"

  FileUtils.mkpath(File.dirname(path))

  File.open(path, 'w') do |f|
    f.puts <<-END
---
title: #{title}
date: #{date}
---

```poem

```
    END
  end

  puts path
  system 'e', path
end

desc "Run svgo on .inkscape.svg files"
task :svgo do
  Dir.glob("**/*.inkscape.svg") do |src_path|
    dest_path = src_path.sub(".inkscape.svg", ".svg")
    system("svgo", src_path, "-o", dest_path)
  end
end

desc "Fetch drawings"
task :drawings do
  require 'yaml'
  require 'fileutils'

  dest_dir = 'source/gallery/images'

  FileUtils.mkdir_p(dest_dir)

  errors = []

  # cmd = "aws s3 cp s3://puyofiles/gallery/ #{dest_dir} --profile puyo"
  # puts cmd
  # system(cmd)

  image_paths = Dir.glob(File.join(dest_dir, '*.*')).reject{|path| path.end_with?('thumb.jpg') }

  records = image_paths.map do |path|
    filename = File.basename(path)
    puts filename
    date_str = filename.match(/^(\d\d\d\d-\d\d-\d\d)/).captures.first
    thumb_filename = File.basename(filename, File.extname(path)) + '.thumb.jpg'
    thumb_path = File.join(dest_dir, thumb_filename)
    thumb_w = thumb_h = nil

    if !File.exist?(thumb_path)
      cmd = "convert #{path} -auto-orient -thumbnail 500x200 -unsharp 0x.5 #{thumb_path}"
      puts cmd
      system(cmd)
    end
    thumb_w, thumb_h = `identify -ping -format '%w %h' #{thumb_path}`.to_s.strip.split(' ')

    {
      'date_time' => date_str,
      'filename' => filename,
      'thumb_filename' => thumb_filename,
      'thumb_width' => thumb_w.to_i,
      'thumb_height' => thumb_h.to_i,
    }
  rescue Errno::ENOENT => e
    errors << e
    nil
  end

  records.compact!

  records.sort_by!{|r| r['date_time'] }

  if errors.any?
    errors.each do |e|
      warn e
    end
  end

  File.open('data/lifedrawing.yml', 'w') do |f|
    YAML.dump(records, f)
  end
end
