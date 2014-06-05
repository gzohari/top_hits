# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'top_hits/version'

Gem::Specification.new do |spec|
  spec.name          = "top_hits"
  spec.version       = TopHits::VERSION
  spec.authors       = ["Gilad Zohari"]
  spec.email         = ["gzohari@gmail.com"]
  spec.summary       = %q{}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "minitest"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "database_cleaner"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "fakeweb"

  spec.add_dependency "sidekiq"
  spec.add_dependency "nokogiri"
  spec.add_dependency "mysql2"
  spec.add_dependency "mechanize"
end
