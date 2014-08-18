# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kilometric/version'

Gem::Specification.new do |spec|
  spec.name          = "kilometric"
  spec.version       = KiloMetric::VERSION
  spec.authors       = ["Alexander Ponomarev"]
  spec.email         = ["ikidoit@gmail.com"]
  spec.description   = %q{Event tracking for Ruby}
  spec.summary       = %q{Simple, modular redis/ruby-based event tracking}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "redis"
  spec.add_dependency "json"
  spec.add_dependency "activesupport"
  spec.add_dependency "dante"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
end
