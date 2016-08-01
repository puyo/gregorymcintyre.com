task default: [:upload]

desc 'Upload to gregorymcintyre.com'
task publish: :build do
  sh 'rsync -rvP --delete build/ gregorymcintyre.com:gregorymcintyre.com/'
end


desc 'Regenerate the static site'
task :build do
  sh 'middleman build'
end

desc 'Create a new poem. rake poem title="One Two Three"'
task :poem do
  require 'middleman-core/util/uri_templates'
  require 'fileutils'

  include Middleman::Util::UriTemplates

  title = ENV['title']
  if !title or title.empty?
    raise 'Must supply poem title. e.g. rake poem title="One Two Three"'
  end
  date = Time.now.strftime('%Y-%m-%d %H:%M %Z')
  slug = safe_parameterize(title)
  path = "source/poetry/articles/#{slug}/index.html.md"

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
  system 'g', path
end
