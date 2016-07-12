# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'polly_phone/version'

Gem::Specification.new do |spec|
  spec.name          = "polly_phone"
  spec.version       = PollyPhone::VERSION
  spec.date          = "2016-07-10"
  spec.summary       = "PollyPhone!"
  spec.description   = "A simple gem for searching mobile phones from internet"
  spec.authors       = ["artkalmyk"]
  spec.email         = ["artyom.kalm@gmail.com"]

  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", "~> 1.6.8"
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 0.10.0"
end
