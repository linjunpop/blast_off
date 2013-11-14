# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blast_off/version'

Gem::Specification.new do |spec|
  spec.name          = "blast_off"
  spec.version       = BlastOff::VERSION
  spec.authors       = ["Jun Lin"]
  spec.email         = ["linjunpop@gmail.com"]
  spec.description   = "An iOS beta distribution tool."
  spec.summary       = "An iOS beta distribution tool."
  spec.homepage      = "https://github.com/linjunpop/blast_off"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", '~> 2.14'
  spec.add_development_dependency "nokogiri", '~> 1.6'

  spec.add_runtime_dependency 'gli','~> 2.8.1'
  spec.add_runtime_dependency 'qiniu-rs', '~> 3.4.6'
  spec.add_runtime_dependency 'rainbow', '~> 1.1.4'
  spec.add_runtime_dependency 'ipa_reader', '~> 0.7.1'
  spec.add_runtime_dependency 'CFPropertyList'
end
