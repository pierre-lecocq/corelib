# File: connectable.rb
# Time-stamp: <2018-02-22 23:53:57>
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
      attr_accessor :_connections

      # Create a connection and store it
      #
      # @param name [Symbol]
      # @param config [Hash]
      #
      # @return [Object]
      def connect(name, config)
        @_connections ||= {}
        @_connections[name] = new config

        @_connections[name]
      end

      # Get a connection by its name
      #
      # @param name [Symbol]
      def connection(name = :default)
        @_connections[name] || raise("Undefined #{self} connection '#{name}'")
      end
    end
  end
end
