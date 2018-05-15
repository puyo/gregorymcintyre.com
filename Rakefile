task default: [:usage]

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
    raise 'Must supply poem title. e.g. rake poem title="One Two Three"'
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
