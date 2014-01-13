namespace :copy do

  archive_name = "archive.tar.gz"

  desc "Archive files to #{archive_name}"
  file archive_name => FileList["*"].exclude(archive_name) do |t|
    sh "tar -cvzf #{t.name} #{t.prerequisites.join(" ")}"
  end

  desc "Deploy #{archive_name} to release_path"
  task :deploy => archive_name do |t|
    tarball = t.prerequisites.first
    on roles :all do

      # Make sure the release directory exists
      execute :mkdir, "-p", release_path

      # Create a temporary file on the server
      tmp_file = capture("mktemp")

      # Upload the archive, extract it and finally remove the tmp_file
      upload!(tarball, tmp_file)
      execute :tar, "-xzf", tmp_file, "-C", release_path
      execute :rm, tmp_file
    end

    Rake::Task["copy:clean"].invoke

  end

  task :clean do |t|
    # Delete the local archive
    File.delete archive_name if File.exists? archive_name
  end

  task :create_release => :deploy

  task :check

end