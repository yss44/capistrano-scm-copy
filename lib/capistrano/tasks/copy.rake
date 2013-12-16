
namespace :copy do

  file "archive.tar.gz" => FileList["*"].exclude("archive.tar.gz") do |t|
    sh "tar -cvzf #{t.name} #{t.prerequisites.join('  ')}"
  end

  desc "Deploy archive.tar.gz to release_path"
  task :deploy => "archive.tar.gz" do |t|
    tarball = t.prerequisites.first
    on roles :all do
      execute :mkdir, "-p", "#{fetch(:tmp_dir)}/#{fetch(:application)}"
      upload!(tarball, "#{fetch(:tmp_dir)}/#{fetch(:application)}/capistrano-scm-copy")
      execute :mkdir, "-p", release_path
      execute :tar, "-xzf", "#{fetch(:tmp_dir)}/#{fetch(:application)}/capistrano-scm-copy", "-C", release_path
    end
  end

  task :create_release => :deploy

  task :check

end