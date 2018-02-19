# File: corelib_spec.rb
# Time-stamp: <2018-02-09 22:12:31>
# Copyright (C) 2018 Pierre Lecocq
# Description: Corelib spec

require_relative '../lib/corelib'

describe Corelib do
  describe 'VERSION' do
    it 'should match the 1.0.0 version' do
      expect(Corelib::VERSION).to be == '1.0.0'
    end
  end
end
