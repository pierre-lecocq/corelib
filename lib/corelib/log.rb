# File: log.rb
# Time-stamp: <2018-02-20 10:28:27>
# Copyright (C) 2018 Pierre Lecocq
# Description: Log singleton  class

module Corelib
  # Loggable module
  module Loggable
    # Check setup if included
    #
    # @param base [Class]
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
    attr_accessor :_handler

    # Setup the log handler
    #
    # @param device [String, IO] A file or an IO device
    # @param roate [String] Periodicity for rotation
    # @param config [Hash] Extra options
    def self.setup(output = STDOUT, rotate = 'daily', options = {})
      instance._handler = ::Logger.new output, rotate

      unless options.key? :formatter
        options[:formatter] = proc { |severity, time, progname, msg|
          identity = progname.nil? ? '' : " #{progname} -"
          "[#{time}]#{identity} #{severity.ljust 5} : #{msg}\n"
        }
      end

      instance._handler.formatter = options[:formatter]
      instance._handler.progname = options[:progname] if options.key? :progname
      instance._handler.level = options[:level] if options.key? :level
    end

    # Log a debug
    #
    # @param message [String]
    def self.debug(message)
      instance._handler.debug message
    end

    # Log an info
    #
    # @param message [String]
    def self.info(message)
      instance._handler.info message
    end

    # Log a warning
    #
    # @param message [String]
    def self.warn(message)
      instance._handler.warn message
    end

    # Log an error
    #
    # @param message [String]
    def self.error(message)
      instance._handler.error message
    end
  end
end
