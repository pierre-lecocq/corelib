# File: database.rb
# Time-stamp: <2018-02-22 13:52:26>
# Copyright (C) 2018 Pierre Lecocq
# Description: Database class

module Corelib
  # Database class
  class Database
    include Connectable

    # Handler accessor
    attr_accessor :handler

    # Stats accessor
    attr_accessor :stats

    # Initialize the database handler
    #
    # @param config [Hash]
    def initialize(config)
      keys = %i[host dbname user password]

      raise "Invalid database config. It must include #{keys.join ', '}" \
        unless keys.all?(&config.method(:key?))

      @stats = {}
      @handler = ::PG.connect config
    end

    # Check handler health
    #
    # @return [Boolean]
    def alive?
      @handler.status == PG::Connection::CONNECTION_OK
    end

    # Execute query with params
    #
    # @param query [String]
    # @param params [Array]
    # @param conn [PG::Connection, nil]
    #
    # @return [PG::Result]
    def exec_params(query, params = [], conn = nil)
      stat_query query
      conn ||= @handler
      conn.exec_params query, params
    end

    # Open a transaction and close it after the block execution
    #
    # @param block [Proc]
    #
    # @return [PG::Connection]
    def transaction(&block)
      @handler.transaction(&block)
    end

    # Add stat for a query
    #
    # @param query [String]
    def stat_query(query)
      verb = query.split(' ').first.downcase.to_sym
      @stats[verb] = 0 unless @stats.key? verb
      @stats[verb] += 1
    end
  end
end
