# File: corelib.gemspec
# Time-stamp: <2018-02-22 23:12:37>
# Copyright (C) 2018 Pierre Lecocq
# Description: Gemspec

require_relative 'lib/corelib'

Gem::Specification.new do |s|
  s.name        = 'corelib'
  s.version     = Corelib::VERSION
  s.date        = '2018-02-01'
  s.summary     = 'Core library for web apps'
  s.description = 'A collection of useful classes for simple and fast web applications'
  s.authors     = 'Pierre Lecocq'
  s.email       = 'pierre.lecocq@gmail.com'
  s.files       = Dir.glob('{test,lib}/**/*') + %w[README.md Gemfile Rakefile LICENSE]
  s.homepage    = 'https://github.com/pierre-lecocq/corelib'
  s.license     = 'MIT'
end
