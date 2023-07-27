# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cognito/version'

Gem::Specification.new do |spec|
  spec.name          = 'cognito-client'
  spec.version       = Cognito::VERSION
  spec.authors       = ['Connor Jacobsen', 'Delmer Reed', 'Alain Meier']
  spec.email         = ['connor@opendoor.com', 'delmer@blockscore.com', 'alain@blockscore.com']

  spec.summary       = 'Unofficial Ruby client for the BlockScore Cognito API'
  spec.homepage      = 'https://github.com/opendoor-labs/cognito'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.2'
  spec.add_development_dependency 'pry', '~> 0.10'

  spec.add_dependency 'abstract_type', '~> 0.0.7'
  spec.add_dependency 'adamantium', '~> 0.2'
  spec.add_dependency 'anima', '~> 0.3.0'
  spec.add_dependency 'concord', '~> 0.1.5'
  spec.add_dependency 'procto', '~> 0.0.3'
  spec.add_dependency 'ice_nine', '~> 0.11.2'

  spec.add_runtime_dependency 'http', '~> 4.4', '>= 4.4.1'
  spec.add_runtime_dependency 'addressable', '~> 2.8'
end
