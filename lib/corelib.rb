# File: corelib.rb
# Time-stamp: <2018-02-22 13:12:21>
# Copyright (C) 2018 Pierre Lecocq
# Description: Corelib main module

require 'json'
require 'singleton'

require_relative 'corelib/modules/connectable'
require_relative 'corelib/modules/propertized'
require_relative 'corelib/modules/schematized'

# Corelib main module
module Corelib
  # Version number as a String
  VERSION = '1.0.0'.freeze

  class << self
    # List of loaded modules
    # @!visibility private
    attr_accessor :_modules
  end

  # Enable modules and load their associated libraries
  #
  # @param modules [Array<Symbol>]
  #
  # @raise [StandardError] if a wrong module name is given
  def self.enable(*modules)
    @_modules ||= []

    modules.each do |m|
      next if @_modules.include? m

      case m
      when :model
        enable :log, :database
      when :log
        require 'logger'
      when :database
        require 'pg'
      when :cache
        require 'memcached'
      when :mailer
        require 'mail'
      when :queue
        require 'beaneater'
      else
        raise "Unknown Corelib module #{m}"
      end

      require_relative "corelib/#{m}"

      @_modules << m
    end
  end
end
