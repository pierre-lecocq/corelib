# File: Rakefile
# Time-stamp: <2018-02-11 15:33:06>
# Copyright (C) 2018 Pierre Lecocq
# Description: Rakefile

########
# spec #
########

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = Dir['test/*_spec.rb'].sort
  task.rspec_opts = '--backtrace --color --format documentation'
end

###########
# rubocop #
###########

require 'rubocop/rake_task'

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ['--display-cop-names']
end

########
# yard #
########

require 'yard'

YARD::Rake::YardocTask.new do |t|
  t.files = ['lib/**/*.rb']
  t.stats_options = ['--list-undoc']
end

###########
# default #
###########

task default: :spec
