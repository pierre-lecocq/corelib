# File: cache.rb
# Time-stamp: <2018-02-22 12:39:17>
# Copyright (C) 2018 Pierre Lecocq
# Description: Cache class

module Corelib
  # Cache class
  class Cache
    class << self
      # Connections pool accessor
      # @!visibility private
      attr_accessor :connections

      # Connect to a cache and store its handler
      #
      # @param name [Symbol]
      # @param config [Hash]
      #
      # @return [Corelib::Cache]
      def connect(name, config)
        @connections ||= {}
        @connections[name] = Cache.new config

        @connections[name]
      end

      # Get a cache connection by its name
      #
      # @param name [Symbol]
      # @param config [Hash]
      def connection(name = :default)
        @connections[name] || raise("Undefined cache connection '#{name}'")
      end
    end

    # Connection accessor
    attr_accessor :connection

    # Stats accessor
    attr_accessor :stats

    # Initialize the database connection
    #
    # @param config [Hash]
    def initialize(config)
      keys = %i[host port]

      raise "Invalid cache config. It must include #{keys.join ', '}" \
        unless keys.all?(&config.method(:key?))

      @stats = { get: 0, set: 0, delete: 0 }
      @connection = ::Memcached.new "#{config[:host]}:#{config[:port]}"
    end

    # Check connection health
    #
    # @return [Boolean]
    def alive?
      @connection.set "health:#{Time.now.to_i}", 1, 1
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
      @connection.get key
    end

    # Set the value of a key
    #
    # @param key [String]
    # @param value [String, Numeric]
    # @param ttl [Integer]
    def set(key, value, ttl = 0)
      @stats[:set] += 1
      @connection.set key, value, ttl
    end

    # Delete a key
    #
    # @param key [String]
    def delete(key)
      @stats[:delete] += 1
      @connection.delete key
    rescue Memcached::NotFound
      nil
    end
  end
end
