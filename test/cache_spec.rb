# File: cache_spec.rb
# Time-stamp: <2018-02-13 21:20:11>
# Copyright (C) 2018 Pierre Lecocq
# Description: Cache singleton class spec

require_relative '../lib/corelib'

Corelib.enable :cache

describe Corelib::Cache do
  before :all do
    Corelib::Cache.setup host: ENV['CACHE_HOST'],
                         port: ENV['CACHE_PORT']

    @key = "test:#{Time.now.to_i}"
  end

  describe '.setup' do
    it 'return a Memcached instance' do
      expect(Corelib::Cache.instance._connection).to be_kind_of(Memcached)
    end
  end

  describe '.alive?' do
    it 'check connection health' do
      expect(Corelib::Cache.alive?).to be == true
    end
  end

  describe '.set' do
    it 'set a key' do
      expect(Corelib::Cache.set(@key, 'yes')).to be == nil
    end
  end

  describe '.get' do
    it 'get a key' do
      expect(Corelib::Cache.get(@key)).to be == 'yes'
    end
  end

  describe '.delete' do
    it 'delete a key' do
      expect(Corelib::Cache.delete(@key)).to be == nil
    end

    it 'fail to get the deleted key' do
      expect { Corelib::Cache.get(@key) }.to raise_error(Memcached::NotFound)
    end
  end
end
