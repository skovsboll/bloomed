module Bloomed
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.join(File.dirname(__FILE__), "tasks/seed.rake")
    end
  end
end
