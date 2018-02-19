# File: cache.rb
# Time-stamp: <2018-02-13 23:51:10>
# Copyright (C) 2018 Pierre Lecocq
# Description: Cache singleton class

module Corelib
  # Cache singleton class
  class Cache
    include Singleton

    # Connection accessor
    # @!visibility private
    attr_accessor :_connection

    # Stats accessor
    # @!visibility private
    attr_accessor :_stats

    # Setup the cache connection
    #
    # @param config [Hash] Required keys: :host, :port
    #
    # @raise [StandardError] if the configuration does not have all required keys
    def self.setup(config)
      keys = %i[host port]

      raise "Invalid cache config. It must include #{keys.join ', '}" \
        unless keys.all?(&config.method(:key?))

      instance._connection = ::Memcached.new "#{config[:host]}:#{config[:port]}"
      instance._stats = {
        get: 0,
        set: 0,
        delete: 0
      }
    end

    # Check connection health
    #
    # @return [Boolean]
    def self.alive?
      instance._connection.set "health:#{Time.now.to_i}", 1, 1
      true
    rescue Memcached::ServerIsMarkedDead
      false
    end

    # Get key
    #
    # @param key [String]
    #
    # @return [String, Numeric]
    def self.get(key)
      instance._stats[:get] += 1
      instance._connection.get key
    end

    # Set the value of a key
    #
    # @param key [String]
    # @param value [String, Numeric]
    # @param ttl [Integer]
    def self.set(key, value, ttl = 0)
      instance._stats[:set] += 1
      instance._connection.set key, value, ttl
    end

    # Delete a key
    #
    # @param key [String]
    def self.delete(key)
      begin
        instance._stats[:delete] += 1
        instance._connection.delete key
      rescue Memcached::NotFound
        nil
      end
    end

    # Get stats
    #
    # @return [Hash]
    def self.stats
      instance._stats
    end
  end
end
