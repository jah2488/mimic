# -*- encoding: utf-8 -*-
require File.expand_path('../lib/mimic/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Justin Herrick"]
  gem.email         = ["justin@justinherrick.com"]
  gem.description   = %q{Minimalistic Library for Mocking, Stubbing, and Faking Classes}
  gem.summary       = %q{Rspec Style Mocking and Stubbing for creating Null Objects and Faking Classes with error handling to keep your Fake's in sync}
  gem.homepage      = "https://github.com/jah2488/mimic"

  gem.add_development_dependency "rspec"
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "mimic"
  gem.require_paths = ["lib"]
  gem.version       = Mimic::VERSION
end
