# File: database_spec.rb
# Time-stamp: <2018-02-13 21:20:19>
# Copyright (C) 2018 Pierre Lecocq
# Description: Database singleton class spec

require_relative '../lib/corelib'

Corelib.enable :database

describe Corelib::Database do
  before :all do
    Corelib::Database.setup host: ENV['DB_HOST'],
                            dbname: ENV['DB_DBNAME'],
                            user: ENV['DB_USER'],
                            password: ENV['DB_PASSWORD']
  end

  describe '.setup' do
    it 'return a PG::Connection instance' do
      expect(Corelib::Database.instance._connection).to be_kind_of(PG::Connection)
    end
  end

  describe '.alive?' do
    it 'check connection health' do
      expect(Corelib::Database.alive?).to be == true
    end
  end
end
