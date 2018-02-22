# File: search_spec.rb
# Time-stamp: <2018-02-22 22:45:45>
# Copyright (C) 2018 Pierre Lecocq
# Description: Search class spec

require_relative '../lib/corelib'

Corelib.enable :search

describe Corelib::Search do
  before :all do
    Corelib::Search.connect :default,
                            host: ENV['SEARCH_HOST']
  end

  describe '.connection' do
    it 'return a Elasticsearch::Client instance' do
      expect(Corelib::Search.connection(:default).handler).to be_kind_of(Elasticsearch::Transport::Client)
    end
  end

  describe '#alive?' do
    it 'check connection health' do
      expect(Corelib::Search.connection(:default).alive?).to be == true
    end
  end

  describe '#index' do
    it 'should create a new document' do
      search = Corelib::Search.connection(:default)

      result = search.index index: 'test',
                            type: 'rspec',
                            body: {
                              title: 'This is a test 1',
                              member_id: 1
                            }

      expect(result).to be_kind_of(Hash)
      expect(result.key?('result')).to be == true
      expect(result['result']).to be == 'created'
    end
  end

  describe '#get' do
    it 'should retrieve a document' do
      search = Corelib::Search.connection(:default)

      result = search.index index: 'test',
                            type: 'rspec',
                            body: {
                              title: 'This is a test 2',
                              member_id: 1
                            }

      result = search.get 'test', 'rspec', result['_id']

      expect(result).to be_kind_of(Hash)
      expect(result.key?('found')).to be == true
      expect(result['found']).to be == true
    end
  end

  describe '#update' do
    it 'should update a document' do
      search = Corelib::Search.connection(:default)

      result = search.index index: 'test',
                            type: 'rspec',
                            body: {
                              title: 'This is a test 3',
                              member_id: 1
                            }

      result = search.update 'test', 'rspec', result['_id'],
                             { title: 'This is a test 4' }

      expect(result).to be_kind_of(Hash)
      expect(result.key?('result')).to be == true
      expect(result['result']).to be == 'updated'
    end
  end

  describe '#delete' do
    it 'should delete a document' do
      search = Corelib::Search.connection(:default)

      result = search.index index: 'test',
                            type: 'rspec',
                            body: {
                              title: 'This is a test 5',
                              member_id: 1
                            }

      result = search.delete 'test', 'rspec', result['_id']

      expect(result).to be_kind_of(Hash)
      expect(result.key?('result')).to be == true
      expect(result['result']).to be == 'deleted'
    end
  end
end
