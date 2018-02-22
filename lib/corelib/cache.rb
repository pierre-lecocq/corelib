# File: cache.rb
# Time-stamp: <2018-02-22 13:10:08>
# Copyright (C) 2018 Pierre Lecocq
# Description: Cache class

module Corelib
  # Cache class
  class Cache
    include Connectable

    # Handler accessor
    attr_accessor :handler

    # Stats accessor
    attr_accessor :stats

    # Initialize the database handler
    #
    # @param config [Hash]
    def initialize(config)
      keys = %i[host port]

      raise "Invalid cache config. It must include #{keys.join ', '}" \
        unless keys.all?(&config.method(:key?))

      @stats = { get: 0, set: 0, delete: 0 }
      @handler = ::Memcached.new "#{config[:host]}:#{config[:port]}"
    end

    # Check handler health
    #
    # @return [Boolean]
    def alive?
      @handler.set "health:#{Time.now.to_i}", 1, 1
      true
    rescue Memcached::ServerIsMarkedDead
      false
    end

    # Get key
    #
    # @param key [String]
    #
    # @return [String, Numeric]
    def get(key)
      @stats[:get] += 1
      @handler.get key
    end

    # Set the value of a key
    #
    # @param key [String]
    # @param value [String, Numeric]
    # @param ttl [Integer]
    def set(key, value, ttl = 0)
      @stats[:set] += 1
      @handler.set key, value, ttl
    end

    # Delete a key
    #
    # @param key [String]
    def delete(key)
      @stats[:delete] += 1
      @handler.delete key
    rescue Memcached::NotFound
      nil
    end
  end
end
