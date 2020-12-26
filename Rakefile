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
  thumb_dir = 'source/gallery/images/thumbs'
  sync_dir = 'sync'

  FileUtils.rm_rf(thumb_dir)
  FileUtils.rm_rf(dest_dir)
  FileUtils.mkdir_p(sync_dir)
  FileUtils.mkdir_p(dest_dir)
  FileUtils.mkdir_p(thumb_dir)

  errors = []

  records = File.read('lifedrawing_s3_paths.txt').each_line.map do |line|
    date_str, path = line.split(' ')
    filename = File.basename(path)
    sync_path = File.join(sync_dir, filename)

    if !File.exist?(sync_path)
      puts filename
      cmd = "aws s3 cp s3://puyofiles/photos/#{path} #{sync_path} --profile puyo"
      puts cmd
      system(cmd)
    end

    require 'digest/sha2'
    sha = Digest::SHA2.new
    sha << File.read(sync_path)
    sha = sha.to_s

    dest_filename = "#{date_str}_#{sha}.jpg"
    dest_path = File.join(dest_dir, dest_filename)
    thumb_filename = dest_filename + '.thumb.jpg'
    thumb_path = File.join(thumb_dir, thumb_filename)

    if !File.exist?(dest_path)
      cmd = "convert #{sync_path} -auto-orient -thumbnail '2000x2000>' #{dest_path}"
      puts cmd
      system(cmd)
    end

    if !File.exist?(thumb_path)
      cmd = "convert #{sync_path} -auto-orient -thumbnail 250x90 -unsharp 0x.5 #{thumb_path}"
      puts cmd
      system(cmd)
    end

    {
      'source_path' => path,
      'source_filename' => filename,
      'date_time' => date_str,
      'dest_filename' => dest_filename,
      'thumb_filename' => thumb_filename,
      'sha' => sha,
    }
  rescue Errno::ENOENT => e
    errors << e
    nil
  end

  records.compact!

  if errors.any?
    errors.each do |e|
      warn e
    end
  end

  File.open('data/lifedrawing.yml', 'w') do |f|
    YAML.dump(records, f)
  end

  dupes = records.group_by{|r| r['sha'] }.select{|s, rs| rs.size > 1 }
  if dupes.size > 0
    puts "DUPES DETECTED:"
    dupes.each do |sha, dupes|
      puts ' ' + dupes.map{|d| d['source_path'] }.inspect
    end
    puts
  end
end
