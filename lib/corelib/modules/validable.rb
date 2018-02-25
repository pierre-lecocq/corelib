# File: validable.rb
# Time-stamp: <2018-02-25 22:19:03>
# Copyright (C) 2018 Pierre Lecocq
# Description: Validable module

module Corelib
  # validable module
  module Validable
    # Include ClassMethods sub-module
    #
    # @param base [Class]
    def self.included(base)
      base.extend ClassMethods
    end

    # Class methods
    module ClassMethods
      # Validate presence of keys in hash
      #
      # @param h [Hash]
      # @param keys [Array<Symbol>]
      #
      # @raise StandardError
      def raise_if_missing_keys(h, *keys)
        missing_keys = keys.reject { |k| h.key?(k) }

        raise "Missing mandatory keys: #{missing_keys.join ', '}" \
          unless missing_keys.empty?
      end
    end
  end
end
