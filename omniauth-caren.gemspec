# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-caren/version'

Gem::Specification.new do |spec|
  spec.name          = "omniauth-caren"
  spec.version       = OmniAuth::Caren::VERSION
  spec.authors       = ["Stefan Vermaas"]
  spec.email         = ["stefan.vermaas@nedap.com"]
  spec.summary       = "OmniAuth for Caren"
  spec.description   = "Something more"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency 'omniauth-oauth2', '>= 1.3.1'
end
