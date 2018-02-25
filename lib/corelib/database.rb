# File: database.rb
# Time-stamp: <2018-02-25 22:22:12>
# Copyright (C) 2018 Pierre Lecocq
# Description: Database class

module Corelib
  # Database class
  class Database
    include Connectable
    include Validable

    # Handler reader
    attr_reader :handler

    # Stats reader
    attr_reader :stats

    # Prepared queries reader
    attr_reader :prepared_queries

    # Initialize the database handler
    #
    # @param config [Hash]
    def initialize(config)
      self.class.raise_if_missing_keys config, :host, :dbname, :user, :password

      @stats = {}
      @prepared_queries = {}
      @handler = ::PG.connect config
    end

    # Check handler health
    #
    # @return [Boolean]
    def alive?
      handler.status == PG::Connection::CONNECTION_OK
    end

    # Execute a query
    #
    # @param query [String]
    # @param conn [PG::Connection, nil]
    #
    # @return [PG::Result]
    def exec(query, conn = nil)
      stat_query query
      conn ||= handler
      conn.exec query
    end

    # Execute a query with params
    #
    # @param query [String]
    # @param params [Array]
    # @param conn [PG::Connection, nil]
    #
    # @return [PG::Result]
    def exec_params(query, params, conn = nil)
      stat_query query
      conn ||= handler
      conn.exec_params query, params
    end

    # Prepare a query
    #
    # @param name [String]
    # @param query [String]
    # @param conn [PG::Connection, nil]
    #
    # @return [PG::Result]
    def prepare(name, query, conn = nil)
      stat_query query
      conn ||= handler
      conn.prepare name, query
    end

    # Execute a prepared query with params
    #
    # @param name [String]
    # @param params [Array]
    # @param conn [PG::Connection, nil]
    #
    # @return [PG::Result]
    def exec_prepared(name, params, conn = nil)
      stat_query query
      conn ||= handler
      conn.exec_prepared name, params
    end

    # Prepare and/or execute a prepared query with params
    #
    # @param name [String]
    # @param query [String]
    # @param params [Array]
    # @param conn [PG::Connection, nil]
    #
    # @return [PG::Result]
    def prepare_or_exec_params(name, query, params, conn = nil)
      conn ||= handler

      unless prepared_queries.key? name
        conn.prepare name, query
        prepared_queries[name] = query
      end

      conn.exec_prepared name, params
    end

    # Open a transaction and close it after the block execution
    #
    # @param block [Proc]
    #
    # @return [PG::Connection]
    def transaction(&block)
      handler.transaction(&block)
    end

    # Add stat for a query
    #
    # @param query [String]
    def stat_query(query)
      verb = query.split(' ').first.downcase.to_sym
      stats[verb] = 0 unless stats.key? verb
      stats[verb] += 1
    end
  end
end
