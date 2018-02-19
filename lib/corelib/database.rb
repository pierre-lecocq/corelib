# File: database.rb
# Time-stamp: <2018-02-13 23:50:34>
# Copyright (C) 2018 Pierre Lecocq
# Description: Database singleton class

module Corelib
  # Database singleton class
  class Database
    include Singleton

    # Connection accessor
    # @!visibility private
    attr_accessor :_connection

    # Stats accessor
    # @!visibility private
    attr_accessor :_stats

    # Setup the database connection
    #
    # @param config [Hash] Required keys: :host, :dbname, :user, :password
    #
    # @raise [StandardError] if the configuration does not have all required keys
    def self.setup(config)
      keys = %i[host dbname user password]

      raise "Invalid database config. It must include #{keys.join ', '}" \
        unless keys.all?(&config.method(:key?))

      instance._connection = ::PG.connect config
      instance._stats = {
        select: 0,
        insert: 0,
        update: 0,
        delete: 0
      }
    end

    # Check connection health
    #
    # @return [Boolean]
    def self.alive?
      instance._connection.status == PG::Connection::CONNECTION_OK
    end

    # Execute query with params
    #
    # @param query [String]
    # @param params [Array]
    # @param conn [PG::Connection, nil]
    #
    # @return [PG::Result]
    def self.exec_params(query, params = [], conn = nil)
      verb = query.split(' ').first.downcase.to_sym
      instance._stats[verb] += 1 if instance._stats.key? verb

      conn ||= instance._connection
      conn.exec_params query, params
    end

    # Transaction
    #
    # @param block [Proc]
    #
    # @return [PG::Connection]
    def self.transaction(&block)
      instance._connection.transaction(&block)
    end

    # Get stats
    #
    # @return [Hash]
    def self.stats
      instance._stats
    end
  end
end
