task default: [:upload]

desc 'Upload to do.poetry.gregorymcintyre.com'
task upload: :build do
  sh 'rsync -rvP --delete build/ do.gregorymcintyre.com:gregorymcintyre.com/'
end


desc 'Regenerate the static site'
task :build do
  sh 'middleman build'
end
