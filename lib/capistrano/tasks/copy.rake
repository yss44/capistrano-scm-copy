file "archive.tar.gz" => FileList["*"].exclude("archive.tar.gz") do |t|
  sh "tar -cvzf #{t.name} #{t.prerequisites.join('  ')}"
end

namespace :copy do

  desc "Compress the local working directory"
  task :compress => "archive.tar.gz"

  desc "Upload the archive to a temporary directory on the server"
  task :upload => :compress do
    on release_roles :all do

    end
  end

  desc "Decompress archive to release directory"
  task :decompress do
    # ...
  end

  desc "create_release"
  task :create_release do
    puts "create_release!"
    Process.exit!(false)
  end

  desc 'Check that the repository is reachable'
  task :check do
    puts "check!"
    Process.exit!(false)
  end

end