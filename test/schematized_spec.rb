# File: schematized_spec.rb
# Time-stamp: <2018-02-21 21:51:03>
# Copyright (C) 2018 Pierre Lecocq
# Description: Schematized module spec

require_relative '../lib/corelib'

describe Corelib::Schematized do
  before :all do
    class TestSchematized
      include Corelib::Schematized

      schema :test,
             test_id:   { primary_key: true },
             test_col:  {}
    end

    @object = TestSchematized.new
  end

  describe '.table' do
    it 'should return the table name at class level' do
      expect(TestSchematized.schema_attr(:table)).to be == :test
    end
  end

  describe '#table' do
    it 'should return the table name at instance level' do
      expect(@object.schema_attr(:table)).to be == :test
    end
  end

  describe '.primary_key' do
    it 'should return the primary key at class level' do
      expect(TestSchematized.schema_attr(:primary_key)).to be == :test_id
    end
  end

  describe '#primary_key' do
    it 'should return the primary key at instance level' do
      expect(@object.schema_attr(:primary_key)).to be == :test_id
    end
  end

  describe '.columns' do
    it 'should return the columns at class level' do
      expect(TestSchematized.schema_attr(:columns).keys).to be == %i[test_id test_col]
    end
  end

  describe '#columns' do
    it 'should return the columns at instance level' do
      expect(@object.schema_attr(:columns).keys).to be == %i[test_id test_col]
    end
  end
end
