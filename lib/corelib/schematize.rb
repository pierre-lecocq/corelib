# File: schematize.rb
# Time-stamp: <2018-02-12 23:17:21>
# Copyright (C) 2018 Pierre Lecocq
# Description: Schematize module

module Corelib
  # Schematize module
  module Schematize
    # Include InstanceMethods sub-module and include ClassMethods sub-module
    #
    # @param base [Class]
    def self.included(base)
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    # Instance methods
    module InstanceMethods
      # Get schema attribute value
      #
      # @param key [Symbol]
      #
      # @return [Symbol, Hash, Array]
      def schema_attr(key)
        self.class._schema[key]
      end
    end

    # Class methods
    module ClassMethods
      # Schema accessor
      # @!visibility private
      attr_accessor :_schema

      # Schema definition
      #
      # @param table [Symbol]
      # @param columns [Hash]
      def schema(table, columns)
        primary_key = columns.select { |_, h| h[:primary_key] == true }.keys.first
        raise 'Missing primary_key declared column' unless primary_key

        @_schema = {
          table: table,
          columns: columns,
          primary_key: primary_key
        }
      end

      # Get schema attribute value
      #
      # @param key [Symbol]
      #
      # @return [Symbol, Hash, Array]
      def schema_attr(key)
        @_schema[key]
      end
    end
  end
end
