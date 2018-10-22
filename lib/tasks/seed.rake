require File.join(File.dirname(__FILE__), "../seeder")

namespace :bloomed do
  desc "Download the latest password list from pwnedpasswords.com. Warning! It's more than 22GB and will take a while."
  task :download do
    unless File.exist? "pwned-passwords-ordered-by-count.txt"
      `curl -O https://downloads.pwnedpasswords.com/passwords/pwned-passwords-ordered-by-count.7z; 7za e pwned-passwords-ordered-by-count.7z; rm pwned-passwords-ordered-by-count.7z;`
    end
  end

  task :seed_gem_dir, [:large] => [:download] do |_, args|
    Seeder.seed all: args[:large]
  end

  desc "Generate stanard binary bloom filters. Default is top 10.000 and 100.000 with 0.01, 0.001 and 0.0001. Using [large] will add top 1M, 10M and 100M."
  task :seed, [:large] => [:download] do |_, args|
    Seeder.seed all: args[:large], cache_dir: Dir.getwd
  end
end
