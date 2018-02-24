# File: model_spec.rb
# Time-stamp: <2018-02-24 23:11:50>
# Copyright (C) 2018 Pierre Lecocq
# Description: Model spec

require_relative '../lib/corelib'

Corelib.enable :model

describe Corelib::Model do
  before :all do
    @conn = Corelib::Database.connection :default
    @conn.exec 'CREATE TABLE IF NOT EXISTS test_tmp' \
               ' ( test_tmp_id SERIAL PRIMARY KEY, name TEXT );'

    class TestModel < Corelib::Model
      schema :test_tmp,
             test_tmp_id: { primary_key: true },
             name: {}
    end
  end

  after :all do
    @conn.exec 'DROP TABLE IF EXISTS test_tmp'
  end

  describe '.validate_properties' do
    it 'should validate properties' do
      properties = { name: 'test' }

      expect(TestModel.validate_properties(properties)).to be == properties
    end

    it 'should fail to falidate properties' do
      properties = { notfound: 1 }

      expect { TestModel.validate_properties(properties) }.to raise_error "Unknown 'notfound' property for model TestModel"
    end
  end

  describe '.format_value' do
    it 'should format with to_i' do
      expect(TestModel.format_value('1', formatter: :to_i)).to be == 1
    end

    it 'should format an Integer' do
      expect(TestModel.format_value('1', type: Integer)).to be == 1
    end
    it 'should format with to_f' do
      expect(TestModel.format_value('1.2', formatter: :to_f)).to be == 1.2
    end

    it 'should format an Float' do
      expect(TestModel.format_value('1.2', type: Float)).to be == 1.2
    end
  end

  describe '.create' do
    it 'should create an object' do
      object = TestModel.create name: 'test'

      expect(object).to be_kind_of(TestModel)
      expect(object.name).to be == 'test'
    end
  end

  describe '#update' do
    it 'should update an object' do
      object = TestModel.create name: 'test'

      object.update name: 'test2'

      expect(object.name).to be == 'test2'
    end
  end

  describe '#delete' do
    it 'should delete an object' do
      object = TestModel.create name: 'test'

      object.delete

      expect { object.name }.to raise_error NoMethodError
    end
  end
end
