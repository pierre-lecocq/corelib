# File: propertize_spec.rb
# Time-stamp: <2018-02-13 23:18:49>
# Copyright (C) 2018 Pierre Lecocq
# Description: Propertize module spec

require_relative '../lib/corelib'

describe Corelib::Propertize do
  before :all do
    class TestPropertize
      include Corelib::Propertize

      def initialize(props)
        update_properties props
      end
    end

    @object = TestPropertize.new key1: 'value1',
                                 key2: 'value2'
  end

  describe '#all_properties' do
    it 'should return all properties' do
      expect(@object.all_properties).to be == { key1: 'value1', key2: 'value2' }
    end
  end

  describe '#property' do
    { key1: 'value1', key2: 'value2' }.each do |key, value|
      it "should respond to '#{key}'" do
        expect(@object).to respond_to(key)
      end

      it "should return '#{value}' for property '#{key}' with direct access" do
        expect(@object.send(key)).to be == value
      end

      it "should return '#{value}' for property '#{key}' with indirect access" do
        expect(@object.property(key)).to be == value
      end
    end

    it "should not respond to 'notfound' with direct access" do
      expect { @object.send :notfound }.to raise_error NoMethodError
    end

    it "should not respond to 'notfound' with indirect access" do
      expect { @object.property :notfound }.to raise_error NoMethodError
    end
  end
end
