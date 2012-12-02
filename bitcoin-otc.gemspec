#!/usr/bin/env ruby -rubygems
# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.version            = File.read('VERSION').chomp
  gem.date               = File.mtime('VERSION').strftime('%Y-%m-%d')

  gem.name               = 'bitcoin-otc'
  gem.homepage           = 'http://cypherpunk.rubyforge.org/bitcoin-otc/'
  gem.license            = 'Public Domain' if gem.respond_to?(:license=)
  gem.summary            = 'A Ruby library for fetching #bitcoin-otc ratings.'
  gem.description        = gem.summary
  gem.rubyforge_project  = 'cypherpunk'

  gem.author             = 'Arto Bendiken'
  gem.email              = 'arto@bendiken.net'

  gem.platform           = Gem::Platform::RUBY
  gem.files              = %w(AUTHORS CREDITS README UNLICENSE VERSION) + Dir.glob('lib/**/*.rb')
  gem.bindir             = %q(bin)
  gem.executables        = %w()
  gem.default_executable = gem.executables.first
  gem.require_paths      = %w(lib)
  gem.extensions         = %w()
  gem.test_files         = %w()
  gem.has_rdoc           = false

  gem.required_ruby_version      = '>= 1.8.1'
  gem.requirements               = []
  gem.add_development_dependency 'yard',  '>= 0.8.3'
  gem.add_development_dependency 'rspec', '>= 2.12.0'
  gem.post_install_message       = nil
end
