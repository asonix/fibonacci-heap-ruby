# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "fibonacci_heap/version"

Gem::Specification.new do |spec|
  spec.name          = "fibonacci_heap"
  spec.version       = FibonacciHeap::VERSION
  spec.authors       = ["Riley Trautman"]
  spec.email         = ["asonix.dev@gmail.com"]

  spec.summary       = %q{A quick implementation of a fibonacci heap in Ruby}
  spec.homepage      = "https://github.com/asonix/fibonacci_heap.git"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
