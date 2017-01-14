# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$:.push File.expand_path('../lib/kubeclient/lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruboty/k8s/version'

Gem::Specification.new do |spec|
  spec.name          = "ruboty-k8s"
  spec.version       = Ruboty::K8s::VERSION
  spec.authors       = ["cnosuke"]
  spec.email         = ["shinnosuke@gmail.com"]

  spec.summary       = "Ruboty handlerf for Kubernetes (k8s)"
  spec.homepage      = "https://github.com/cnosuke/ruboty-k8s"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Dependency for kubeclient
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'webmock', '~> 1.24.2'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'rubocop', '= 0.46.0'
  spec.add_dependency 'rest-client'
  spec.add_dependency 'recursive-open-struct', '= 1.0.0'
  spec.add_dependency 'http', '= 0.9.8'

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
