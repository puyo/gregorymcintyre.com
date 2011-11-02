task :default => [:upload]

desc 'Upload to gregorymcintyre.com'
task :upload => :regen do
  sh 'rsync -rv --delete build/ puyo@gregorymcintyre.com:gregorymcintyre.com/'
end

desc 'Regenerate the static site'
task :regen do
  sh 'middleman build'
end
