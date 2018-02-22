# File: database.rb
# Time-stamp: <2018-02-22 12:25:07>
# Copyright (C) 2018 Pierre Lecocq
# Description: Database singleton class

module Corelib
  # Database class
  class Database
    class << self
      # Connections pool accessor
      # @!visibility private
      attr_accessor :connections

      # Connect to a database and store its handler
      #
      # @param name [Symbol]
      # @param config [Hash]
      #
      # @return [Corelib::Database]
      def connect(name, config)
        @connections ||= {}
        @connections[name] = Database.new config

        @connections[name]
      end

      # Get a database connection by its name
      #
      # @param name [Symbol]
      # @param config [Hash]
      def connection(name = :default)
        @connections[name] || raise("Undefined database connection '#{name}'")
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
      @stats = {}
      @connection = ::PG.connect config
    end

    # Check connection health
    #
    # @return [Boolean]
    def alive?
      @connection.status == PG::Connection::CONNECTION_OK
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
      conn ||= @connection
      conn.exec_params query, params
    end

    # Open a transaction and close it after the block execution
    #
    # @param block [Proc]
    #
    # @return [PG::Connection]
    def transaction(&block)
      @connection.transaction(&block)
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
