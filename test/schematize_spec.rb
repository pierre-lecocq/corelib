# File: schematize_spec.rb
# Time-stamp: <2018-02-12 23:49:39>
# Copyright (C) 2018 Pierre Lecocq
# Description: Schematize module spec

require_relative '../lib/corelib'

describe Corelib::Schematize do
  before :all do
    class TestSchematize
      include Corelib::Schematize

      schema :test,
             test_id:   { primary_key: true },
             test_col:  {}
    end

    @object = TestSchematize.new
  end

  describe '.table' do
    it 'should return the table name at class level' do
      expect(TestSchematize.schema_attr(:table)).to be == :test
    end
  end

  describe '#table' do
    it 'should return the table name at instance level' do
      expect(@object.schema_attr(:table)).to be == :test
    end
  end

  describe '.primary_key' do
    it 'should return the primary key at class level' do
      expect(TestSchematize.schema_attr(:primary_key)).to be == :test_id
    end
  end

  describe '#primary_key' do
    it 'should return the primary key at instance level' do
      expect(@object.schema_attr(:primary_key)).to be == :test_id
    end
  end

  describe '.columns' do
    it 'should return the columns at class level' do
      expect(TestSchematize.schema_attr(:columns).keys).to be == %i[test_id test_col]
    end
  end

  describe '#columns' do
    it 'should return the columns at instance level' do
      expect(@object.schema_attr(:columns).keys).to be == %i[test_id test_col]
    end
  end
end
