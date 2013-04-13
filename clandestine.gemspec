# -*- encoding: utf-8 -*-
require File.expand_path('../lib/clandestine/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "clandestine"
  gem.version       = Clandestine::VERSION
  gem.authors       = ["Alec Tower"]
  gem.email         = ["alectower@gmail.com"]
  gem.description   = %q{A ruby command line tool for storing encrypted passwords on *nix systems}
  gem.summary       = %q{A ruby command line tool that uses AES-256-CBC encryption to store passwords. It provides easy storage and retrieval on *nix systems}
  gem.homepage      = "https://github.com/uniosx/clandestine"
  gem.platform      = Gem::Platform::RUBY
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency 'highline'
  gem.add_development_dependency 'rspec', '~>2.8'
end
