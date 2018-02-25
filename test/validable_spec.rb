# File: validable_spec.rb
# Time-stamp: <2018-02-25 22:14:18>
# Copyright (C) 2018 Pierre Lecocq
# Description: Validable module spec

require_relative '../lib/corelib'

describe Corelib::Validable do
  before :all do
    class TestValidable
      include Corelib::Validable
    end

    @h = { k1: 'v1', k2: 'v2' }
  end

  describe '.raise_if_missing_keys' do
    it 'should not raise an error' do
      expect(TestValidable.raise_if_missing_keys(@h, :k1, :k2)).to be_nil
    end

    it 'should raise an error' do
      expect { TestValidable.raise_if_missing_keys(@h, :k1, :k2, :k3) }.to raise_error StandardError
    end
  end
end
