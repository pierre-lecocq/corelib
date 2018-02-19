# File: propertize.rb
# Time-stamp: <2018-02-13 23:14:11>
# Copyright (C) 2018 Pierre Lecocq
# Description: Propertize module

module Corelib
  # Propertize module
  module Propertize
    # Properties accessor
    # @!visibility private
    attr_accessor :_properties

    # Get property value
    #
    # @param name [Symbol]
    #
    # @return [Object]
    def property(name)
      send name.to_sym
    end

    # All properties
    #
    # @return [Hash]
    def all_properties
      @_properties || {}
    end

    # Update properties
    #
    # @param properties [Hash]
    def update_properties(properties)
      @_properties ||= {}
      @_properties.merge! properties
    end

    # Reset properties
    def reset_properties
      @_properties = {}
    end

    # Method missing
    #
    # @param method [Symbol]
    # @param args [Array]
    # @param block [Proc]
    def method_missing(method, *args, &block)
      if @_properties.key?(method.to_sym)
        @_properties[method.to_sym] || nil
      else
        super
      end
    end

    # Respond to missing method
    #
    # @param method [Symbol]
    # @param include_private [Boolean]
    def respond_to_missing?(method, include_private = false)
      @_properties.key?(method.to_sym) || super
    end
  end
end
