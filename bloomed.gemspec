
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bloomed/version"

Gem::Specification.new do |spec|
  spec.name          = "bloomed"
  spec.version       = Bloomed::VERSION
  spec.authors       = ["Søren Skovsbøll"]
  spec.email         = ["soren@wero.es"]

  spec.summary       = "Bloom filter check for pwned passwords"
  spec.description   = "Check your users' passwords using a fraction of the memory of the full pwned passwords list."
  spec.homepage      = "https://github.com/skovsboll/bloomed"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bloomer", "~> 1.0"
  spec.add_dependency "msgpack"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rspec_junit_formatter"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
end
