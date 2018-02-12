# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'faraday/panoptes/version'

Gem::Specification.new do |spec|
  spec.name          = "faraday-panoptes"
  spec.version       = Faraday::Panoptes::VERSION
  spec.authors       = ["Marten Veldthuis"]
  spec.email         = ["marten@veldthuis.com"]

  spec.summary       = %q{Faraday middleware for talking to the Panoptes API}
  spec.description   = %q{Provides middleware to set the correct request headers, and handle authentication for Zooniverse's Panoptes API.}
  spec.homepage      = "https://github.com/zooniverse/faraday-panoptes"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'faraday', '~> 0.9'
  spec.add_dependency 'faraday_middleware', '~> 0.10'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "openssl"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
end
