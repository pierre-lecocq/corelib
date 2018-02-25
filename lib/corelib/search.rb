# File: search.rb
# Time-stamp: <2018-02-25 22:24:50>
# Copyright (C) 2018 Pierre Lecocq
# Description: Search class

module Corelib
  # Search class
  class Search
    include Connectable
    include Validable

    # Handler reader
    attr_reader :handler

    # Initialize the search handler
    #
    # @param config [Hash]
    def initialize(config)
      self.class.raise_if_missing_keys config, :host

      @handler = ::Elasticsearch::Client.new config
    end

    # Check handler health
    #
    # @return [Boolean]
    def alive?
      handler.ping != false
    end

    # Create a document
    # http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#index-instance_method
    #
    # @param data [Hash]
    #
    # @return [Hash]
    def index(data)
      self.class.raise_if_missing_keys data, :index, :type, :body

      handler.index data
    end

    # Search in the cluster
    # http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#search-instance_method
    #
    # @param index [String]
    # @param body [Hash]
    #
    # @return [Hash]
    def search(index, body)
      handler.search index: index, body: body
    end

    # Get a document
    # http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#get-instance_method
    #
    # @param index [String]
    # @param type [String]
    # @param id [String]
    #
    # @return [Object]
    def get(index, type, id)
      handler.get index: index, type: type, id: id
    end

    # Update partially a document
    # http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#update-instance_method
    #
    # @param index [String]
    # @param type [String]
    # @param id [String]
    # @param body [Hash]
    #
    # @return [Object]
    def update(index, type, id, body)
      handler.update index: index, type: type, id: id, body: { doc: body }
    end

    # Delete a document
    # http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#delete-instance_method
    #
    # @param index [String]
    # @param type [String]
    # @param id [String]
    #
    # @return [Object]
    def delete(index, type, id)
      handler.delete index: index, type: type, id: id
    end
  end
end
