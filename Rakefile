require "bundler/gem_tasks"
require "rspec/core/rake_task"
require_relative 'lib/seeder'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :download do
  unless File.exist? "pwned-passwords-ordered-by-count.txt"
    `curl -O https://downloads.pwnedpasswords.com/passwords/pwned-passwords-ordered-by-count.7z; 7za e pwned-passwords-ordered-by-count.7z; rm pwned-passwords-ordered-by-count.7z;`
  end
end

task :seed, [:all] => [:download] do |_, args|
  Seeder.seed all: args[:all]
end

task :seed_here, [:all] => [:download] do |_, args|
  Seeder.seed all: args[:all], cache_dir: Dir.getwd
end
