# File: log_spec.rb
# Time-stamp: <2018-02-19 23:17:57>
# Copyright (C) 2018 Pierre Lecocq
# Description: Log singleton class spec

require_relative '../lib/corelib'
require 'stringio'

Corelib.enable :log

describe Corelib::Log do
  before :all do
    @fake_file = StringIO.new

    Corelib::Log.setup @fake_file, 'daily', progname: 'testprog'
  end

  before :each do
    @fake_file.truncate 0
  end

  describe '.info' do
    it 'should receive an info' do
      Corelib::Log.info 'test'

      expect(@fake_file.string).to match(/INFO -- testprog: test\n$/)
    end
  end

  describe '.debug' do
    it 'should receive a debug' do
      Corelib::Log.debug 'test'

      expect(@fake_file.string).to match(/DEBUG -- testprog: test\n$/)
    end
  end

  describe '.warn' do
    it 'should receive a warning' do
      Corelib::Log.warn 'test'

      expect(@fake_file.string).to match(/WARN -- testprog: test\n$/)
    end
  end

  describe '.error' do
    it 'should receive an error' do
      Corelib::Log.error 'test'

      expect(@fake_file.string).to match(/ERROR -- testprog: test\n$/)
    end
  end
end
