# File: log.rb
# Time-stamp: <2018-02-25 15:27:22>
# Copyright (C) 2018 Pierre Lecocq
# Description: Log singleton  class

module Corelib
  # Loggable module
  module Loggable
    # Check setup if included
    #
    # @param _base [Class]
    def self.included(_base)
      raise "#{self.class} includes Corelib::Loggable but Corelib::Log is not set up" \
        unless Log.instance._handler
    end
  end

  # Log singleton class
  class Log
    include Singleton

    # Handler accessor
    # @!visibility private
    attr_accessor :handler

    # Setup the log handler
    #
    # @param device [String, IO] A file or an IO device
    # @param rotate [String] Periodicity for rotation
    # @param options [Hash] Extra options
    def self.setup(device = STDOUT, rotate = 'daily', options = {})
      instance.handler = ::Logger.new device, rotate

      unless options.key? :formatter
        options[:formatter] = proc { |severity, time, progname, msg|
          identity = progname.nil? ? '' : " #{progname} -"
          "[#{time}]#{identity} #{severity.ljust 5} : #{msg}\n"
        }
      end

      instance.handler.formatter = options[:formatter]
      instance.handler.progname = options[:progname] if options.key? :progname
      instance.handler.level = options[:level] if options.key? :level
    end

    # Log a debug
    #
    # @param message [String]
    def self.debug(message)
      instance.handler.debug message
    end

    # Log an info
    #
    # @param message [String]
    def self.info(message)
      instance.handler.info message
    end

    # Log a warning
    #
    # @param message [String]
    def self.warn(message)
      instance.handler.warn message
    end

    # Log an error
    #
    # @param message [String]
    def self.error(message)
      instance.handler.error message
    end
  end
end
