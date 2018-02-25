# File: cache_spec.rb
# Time-stamp: <2018-02-25 15:24:43>
# Copyright (C) 2018 Pierre Lecocq
# Description: Cache class spec

require_relative '../lib/corelib'

Corelib.enable :cache

describe Corelib::Cache do
  before :all do
    Corelib::Cache.connect :default,
                           host: ENV['CACHE_HOST'],
                           port: ENV['CACHE_PORT']

    @key = "test:#{Time.now.to_i}"
  end

  describe '.connection' do
    it 'return a Memcached instance' do
      expect(Corelib::Cache.connection.handler).to be_kind_of(Memcached)
    end
  end

  describe '#alive?' do
    it 'check connection health' do
      expect(Corelib::Cache.connection.alive?).to be == true
    end
  end

  describe '#set' do
    it 'set a key' do
      expect(Corelib::Cache.connection.stats[:set]).to be == 0
      expect(Corelib::Cache.connection.set(@key, 'yes')).to be == nil
      expect(Corelib::Cache.connection.stats[:set]).to be == 1
    end
  end

  describe '#get' do
    it 'get a key' do
      expect(Corelib::Cache.connection.stats[:get]).to be == 0
      expect(Corelib::Cache.connection.get(@key)).to be == 'yes'
      expect(Corelib::Cache.connection.stats[:get]).to be == 1
    end
  end

  describe '#delete' do
    it 'delete a key' do
      expect(Corelib::Cache.connection.stats[:delete]).to be == 0
      expect(Corelib::Cache.connection.delete(@key)).to be == nil
      expect(Corelib::Cache.connection.stats[:delete]).to be == 1
    end

    it 'fail to get the deleted key' do
      expect { Corelib::Cache.connection.get(@key) }.to raise_error(Memcached::NotFound)
    end
  end
end
