task default: [:upload]

desc 'Upload to gregorymcintyre.com'
task upload: :build do
  sh 'rsync -rvP --delete build/ gregorymcintyre.com:gregorymcintyre.com/'
end


desc 'Regenerate the static site'
task :build do
  sh 'middleman build'
end
