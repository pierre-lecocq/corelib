# File: log_spec.rb
# Time-stamp: <2018-02-20 10:29:10>
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

      expect(@fake_file.string).to match(/testprog - INFO  : test\n$/)
    end
  end

  describe '.debug' do
    it 'should receive a debug' do
      Corelib::Log.debug 'test'

      expect(@fake_file.string).to match(/testprog - DEBUG : test\n$/)
    end
  end

  describe '.warn' do
    it 'should receive a warning' do
      Corelib::Log.warn 'test'

      expect(@fake_file.string).to match(/testprog - WARN  : test\n$/)
    end
  end

  describe '.error' do
    it 'should receive an error' do
      Corelib::Log.error 'test'

      expect(@fake_file.string).to match(/testprog - ERROR : test\n$/)
    end
  end
end
