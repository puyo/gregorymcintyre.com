task :upload do
  #sh "lftp -f upload.ftp" # Optarse
  ruby "update.rb"
  sh ["rsync -rv",
    "--exclude 'download'",
    "--exclude '*~'",
    "--exclude 'Rakefile'",
    "--exclude '*.ftp'",
    "./ puyo@gregorymcintyre.com:gregorymcintyre.com/"].join(' ')
end

