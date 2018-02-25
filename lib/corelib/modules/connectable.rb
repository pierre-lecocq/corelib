# File: connectable.rb
# Time-stamp: <2018-02-25 15:29:49>
# Copyright (C) 2018 Pierre Lecocq
# Description: Connectable module

module Corelib
  # Connectable module
  module Connectable
    # Include ClassMethods sub-module
    #
    # @param base [Class]
    def self.included(base)
      base.extend ClassMethods
    end

    # Class methods
    module ClassMethods
      # Connections pool accessor
      # @!visibility private
      attr_accessor :connections

      # Create a connection and store it
      #
      # @param name [Symbol]
      # @param config [Hash]
      #
      # @return [Object]
      def connect(name, config)
        @connections ||= {}
        @connections[name] = new config

        @connections[name]
      end

      # Get a connection by its name
      #
      # @param name [Symbol]
      def connection(name = :default)
        @connections[name] || raise("Undefined #{self} connection '#{name}'")
      end
    end
  end
end
