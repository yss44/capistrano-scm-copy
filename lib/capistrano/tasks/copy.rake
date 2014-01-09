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

      # Create a temporary direcotry on the server
      tmp_dir = capture("mktemp")

      # Upload the archive, extract it and finally remove the tmp_dir
      upload!(tarball, tmp_dir)
      execute :tar, "-xzf", tmp_dir, "-C", release_path
      execute :rm, tmp_dir
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