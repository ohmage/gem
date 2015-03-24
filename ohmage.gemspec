lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ohmage/version'

Gem::Specification.new do |spec|
  spec.add_dependency 'addressable'
  spec.add_dependency 'http'
  spec.authors = ['Steve Nolen']
  spec.description = 'A Ruby interface for the ohmage 2.x API.'
  spec.email = %w(technolengy@gmail.com)
  spec.files = %w(LICENSE.txt ohmage.gemspec) + Dir['lib/**/*.rb']
  spec.homepage = 'https://github.com/ohmage/gem'
  spec.licenses = %w(Apache 2)
  spec.name = 'ohmage'
  spec.require_paths = %w(lib)
  spec.required_ruby_version = '>= 1.9.3'
  spec.required_rubygems_version = '>= 1.3.5'
  spec.summary = spec.description
  spec.version = Ohmage::Version
end