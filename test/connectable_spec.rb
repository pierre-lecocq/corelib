# File: connectable_spec.rb
# Time-stamp: <2018-02-22 13:19:59>
# Copyright (C) 2018 Pierre Lecocq
# Description: Connectable module spec

require_relative '../lib/corelib'

describe Corelib::Connectable do
  before :all do
    class TestConnectable
      include Corelib::Connectable

      def initialize(_config); end
    end

    @conn1 = TestConnectable.connect :test1, {}
    @conn2 = TestConnectable.connect :test2, {}
  end

  describe '.connect' do
    it 'should store connections' do
      expect(@conn1).to be_kind_of(TestConnectable)
      expect(@conn2).to be_kind_of(TestConnectable)
    end
  end

  describe '.connection' do
    it 'should retrieve connections' do
      expect(TestConnectable.connection(:test1)).to be == @conn1
      expect(TestConnectable.connection(:test2)).to be == @conn2
    end
  end
end
