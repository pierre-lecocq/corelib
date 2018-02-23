# File: Rakefile
# Time-stamp: <2018-02-23 14:31:21>
# Copyright (C) 2018 Pierre Lecocq
# Description: Rakefile

require_relative 'lib/corelib'

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

#######
# gem #
#######

namespace :gem do
  task :build do
    sh 'gem build corelib.gemspec'
  end

  task :install do
    sh "gem install ./corelib-#{Corelib::VERSION}.gem"
  end
end

##########
# docker #
##########

namespace :docker do
  docker_compose = 'cd docker && docker-compose'

  task :build do
    sh 'cp ./Gemfile ./docker/ruby'
    sh "#{docker_compose} build --pull"
  end

  task :start do
    Rake::Task['docker:build'].invoke
    sh "#{docker_compose} up"
  end

  task :stop do
    sh "#{docker_compose} stop"
  end

  task :clean do
    Rake::Task['docker:stop'].invoke
    sh "#{docker_compose} rm -f"
  end

  task :reset do
    Rake::Task['docker:clean'].invoke
    sh "#{docker_compose} down --rmi local -v --remove-orphans"
  end

  task :lint do
	sh "#{docker_compose} run --rm corelib-ruby /bin/bash -c 'cd /code && rake rubocop'"
  end

  task :test do
	sh "#{docker_compose} run --rm corelib-ruby /bin/bash -c 'cd /code && rake spec'"
  end

  task :doc do
	sh "#{docker_compose} run --rm corelib-ruby /bin/bash -c 'cd /code && rake yard'"
  end
end

###########
# default #
###########

task default: :spec
