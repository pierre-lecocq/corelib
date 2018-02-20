# File: log.rb
# Time-stamp: <2018-02-20 10:19:28>
# Copyright (C) 2018 Pierre Lecocq
# Description: Log example

require_relative '../lib/corelib'

puts "\n[Corelib::Log] --"

# Enable module

Corelib.enable :log

# Setup handler

Corelib::Log.setup

# Log debug

Corelib::Log.debug 'Hello debug'

# Log info

Corelib::Log.info 'Hello info'

# Log warn

Corelib::Log.warn 'Hello warn'

# Log error

Corelib::Log.error 'Hello error'

# Module activation

class ExampleLogDisabled
  def self.test
    puts 'Log is disabled'
    Corelib::Log.info 'Hello' if included_modules.include? Corelib::Loggable
  end
end

class ExampleLogEnabled
  include Corelib::Loggable

  def self.test
    puts 'Log is enabled'
    Corelib::Log.info 'Hello' if included_modules.include? Corelib::Loggable
  end
end

ExampleLogDisabled.test
ExampleLogEnabled.test
